//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
internal import MapKit

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == LiveAddressSearchClient {
    /// Returns live variant of `AddressSearchClient`.
    public static var live: Self {
        .init()
    }
}

extension LiveAddressSearchClient {
    /// A list of ISO country codes for supported regions (e.g., “US” or “GB”).
    ///
    /// If empty then all regions are supported.
    public static var supportedRegions = [Locale.Region.unitedStates]
}

// MARK: - Implementation

public final class LiveAddressSearchClient: AddressSearchClient {
    private typealias L = Localized.PostalAddress
    private var delegates = [UUID: Delegate]()

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        AsyncStream { [weak self] continuation in
            self?.delegates[id] = Delegate { results in
                continuation.yield(results)
            }

            continuation.onTermination = { [weak self] _ in
                self?.delegates[id] = nil
            }
        }
    }

    public func update(id: UUID, searchString: String) {
        delegates[id]?.searchCompleter.queryFragment = searchString
    }

    public func validate(address: PostalAddress) async throws {
        // Check the input address doesn't correspond to a P.O. Box.
        if address.isPoBox {
            throw AppError.postalAddressInvalidPoBox
        }

        guard !Self.supportedRegions.isEmpty else {
            // Early exit as all regions are supported.
            return
        }

        // Check the input address corresponds to US. We check this here to avoid users
        // from entering the details of a US address but select a different country.
        try supportedRegionValidation(address.countryCode)

        let request = MKLocalSearch.Request().apply {
            $0.naturalLanguageQuery = address.description
            $0.resultTypes = .address
        }

        let placemark = try await perform(request: request)

        // Check the result address corresponds to US. We check this here to avoid users
        // from selecting US as country but entering details of an address from a
        // different country.
        try supportedRegionValidation(placemark.countryCode)
    }

    public func map(result: AddressSearchResult) async throws -> PostalAddress {
        let placemark = try await perform(request: result.request())
        return PostalAddress(placemark)
    }

    public func search(query: String) async throws -> PostalAddress {
        let request = MKLocalSearch.Request().apply {
            $0.naturalLanguageQuery = query
            $0.resultTypes = .address
        }

        let placemark = try await perform(request: request)
        return PostalAddress(placemark)
    }

    /// Performs a request to the maps API to obtain a placemark.
    private func perform(request: MKLocalSearch.Request) async throws -> MKPlacemark {
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()

            if let placemark = response.mapItems.first?.placemark {
                return placemark
            } else {
                throw AppError.decodingFailedInvalidData()
            }
        } catch {
            let decodingErrorCodes = [
                MKError.decodingFailed,
                MKError.directionsNotFound,
                MKError.placemarkNotFound
            ]

            if let error = error as? MKError, decodingErrorCodes.contains(error.code) {
                throw AppError.decodingFailed(message: L.invalid)
            }

            throw error.asAppError(or: .decodingFailedInvalidData())
        }
    }

    private func supportedRegionValidation(_ countryCode: String?) throws {
        guard !Self.supportedRegions.isEmpty else {
            // No region restrictions
            return
        }

        let supportedRegions = Self.supportedRegions.map(\.identifier)

        guard let countryCode else {
            throw AppError.decodingFailed(message: L.invalid)
        }

        guard !supportedRegions.contains(countryCode) else {
            return
        }

        typealias LR = L.InvalidRegion
        let appName = Bundle.app.name

        var invalidRegionError = AppError(
            id: "address_validation_failed_invalid_region",
            title: LR.titleOther,
            message: LR.messageMany(appName),
            logLevel: .error
        )

        #warning("Use stringDict to properly localize")

        if supportedRegions.count == 1, let code = supportedRegions.first {
            let isUSA = code == "US"
            let regionName = isUSA ? "U.S." : PostalAddress.countryName(isoCode: code) ?? code
            invalidRegionError.title = LR.titleOne(regionName)
            invalidRegionError.message = LR.messageOne(appName, regionName, regionName)
        } else if supportedRegions.count <= 5 {
            let regions = supportedRegions.formatted(.list(type: .and).locale(.us))
            invalidRegionError.message = LR.messageFew(appName, regions)
        }

        throw invalidRegionError
    }
}

// MARK: - Delegate

extension LiveAddressSearchClient {
    private final class Delegate: NSObject, MKLocalSearchCompleterDelegate, @unchecked Sendable {
        fileprivate let searchCompleter = MKLocalSearchCompleter()
        private let onResults: @Sendable ([AddressSearchResult]) -> Void

        init(onResults: @escaping @Sendable ([AddressSearchResult]) -> Void) {
            self.onResults = onResults
            super.init()
            searchCompleter.delegate = self
            searchCompleter.resultTypes = .address
        }

        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            onResults(completer.results.map(AddressSearchResult.init))
        }

        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            onResults([])
        }

        deinit {
            searchCompleter.cancel()
        }
    }
}

// MARK: - Helpers

extension PostalAddress {
    init(_ item: MKPlacemark) {
        /// Extracting the city from the formatted address lines because "sublocality"
        /// or "locality" are not uniquely identifying the proper city.
        ///
        /// For example, Brooklyn comes as a "sublocality" but Miami Beach comes as
        /// "locality", and Long Island City doesn't come in neither of these
        /// properties.
        ///
        /// However, formatted address lines returns the correct data (e.g., "Brooklyn,
        /// NY 11217"), we are parsing the string and taking the first component,
        /// returning "Brooklyn" correctly as the city.
        ///
        /// We have to check the number of lines on the address as to know where to
        /// fetch the city from: when 4 lines (address with apt number) are present the
        /// city is in position #2. If only 3 lines, then the city is in position #1.
        ///
        /// If the address has 4 lines then we use position #1 to fill `street2`.
        ///
        /// ```swift
        ///
        /// // Brooklyn
        ///
        /// // Sample output from "FormattedAddressLines"
        /// FormattedAddressLines = (
        ///     "222 Jackson St",
        ///     "Unit 5",
        ///     "Brooklyn, NY 11211",
        ///     "United States"
        /// )
        ///
        /// // Complete output of "item.addressDictionary"
        /// {
        ///     City = "New York";
        ///     Country = "United States";
        ///     CountryCode = US;
        ///     FormattedAddressLines = (
        ///         "222 Jackson St",
        ///         "Unit 5", // ⚠️ ← Completely omitted from properties.
        ///         "Brooklyn, NY  11211",
        ///         "United States"
        ///     );
        ///     Name = "222 Jackson St";
        ///     State = NY;
        ///     Street = "222 Jackson St";
        ///     SubAdministrativeArea = "Kings County";
        ///     SubLocality = Brooklyn; // ⚠️ ← Shown under "SubLocality".
        ///     SubThoroughfare = 222;
        ///     Thoroughfare = "Jackson St";
        ///     ZIP = 11211;
        /// }
        ///
        /// // Queens
        ///
        /// // Sample output from "FormattedAddressLines"
        /// FormattedAddressLines = (
        ///     "38-18 Queens Blvd",
        ///     "Long Island City, NY 11101",
        ///     "United States"
        /// )
        ///
        /// // Complete output of "item.addressDictionary"
        /// {
        ///     City = "New York";
        ///     Country = "United States";
        ///     CountryCode = US;
        ///     FormattedAddressLines = (
        ///         "38-18 Queens Blvd",
        ///         "Long Island City, NY  11101",
        ///         "United States"
        ///     );
        ///     Name = "38-18 Queens Blvd";
        ///     State = NY;
        ///     Street = "38-18 Queens Blvd";
        ///     SubAdministrativeArea = "Queens County";
        ///     SubLocality = Queens; // ⚠️ ← Should of been "Long Island City" as shown under "FormattedAddressLines".
        ///     SubThoroughfare = "38-18";
        ///     Thoroughfare = "Queens Blvd";
        ///     ZIP = 11101;
        /// }
        /// ```
        /// - SeeAlso: http://www.openradar.appspot.com/35862589
        let addressLines = item.addressDictionary?["FormattedAddressLines"] as? [String] ?? []

        func getCityField(_ addressLines: [String]) -> String {
            if item.isoCountryCode == "US" {
                // Only one field means we only have the country
                guard addressLines.count > 1 else {
                    return ""
                }

                // City field is located on the 2nd to last position
                return addressLines
                    .at(addressLines.count - 2)?
                    .components(separatedBy: ",")
                    .first ?? ""
            }

            return item.subLocality ?? item.locality ?? ""
        }

        let city = getCityField(addressLines)
        let street2 = addressLines.count > 3 ? addressLines.at(1) : ""

        self.init(
            street1: [item.subThoroughfare, item.thoroughfare].joined(separator: " "),
            street2: street2 ?? "",
            city: city,
            state: item.administrativeArea ?? "",
            postalCode: item.postalCode ?? "",
            countryCode: item.isoCountryCode ?? ""
        )
    }

    /// A Boolean property indicating whether any of the streets corresponds to a
    /// P.O. Box.
    fileprivate var isPoBox: Bool {
        street1.validate(rule: .containsPoBox) || street2.validate(rule: .containsPoBox)
    }
}

// MARK: - App Error

extension AppError {
    /// An error thrown when an address is a P.O. Box.
    ///
    /// ```
    /// // Residential Address
    /// // Please enter an address that doesn’t correspond to a P.O. Box.
    /// ```
    fileprivate static var postalAddressInvalidPoBox: Self {
        typealias L = Localized.PostalAddress.InvalidPoBox
        return .init(
            id: "address_validation_failed_po_box",
            title: L.title,
            message: L.message,
            logLevel: .error
        )
    }
}
