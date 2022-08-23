//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@_implementationOnly import MapKit

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
    public static var supportedRegions = ["US"]
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
        try await withCheckedThrowingContinuation { continuation in
            let search = MKLocalSearch(request: request)

            search.start { response, error in
                guard
                    let response = response,
                    let placemark = response.mapItems.first?.placemark
                else {
                    let decodingErrorCodes = [
                        MKError.decodingFailed,
                        MKError.directionsNotFound,
                        MKError.placemarkNotFound
                    ]

                    if let error = error as? MKError, decodingErrorCodes.contains(error.code) {
                        return continuation.resume(throwing: AppError.decodingFailed(message: L.invalid))
                    }

                    return continuation.resume(throwing: AppError.decodingFailedInvalidData())
                }

                continuation.resume(returning: placemark)
            }
        }
    }

    private func supportedRegionValidation(_ countryCode: String?) throws {
        guard !Self.supportedRegions.isEmpty else {
            // No region restrictions
            return
        }

        let supportedRegions = Self.supportedRegions

        guard let countryCode = countryCode else {
            throw AppError.decodingFailed(message: L.invalid)
        }

        if !supportedRegions.contains(countryCode) {
            typealias L = Localized.PostalAddress.InvalidRegion
            let appName = Bundle.app.name

            var invalidRegion = AppError(
                id: "address_validation_failed_invalid_region",
                title: L.titleOther,
                message: L.messageMany(appName),
                logLevel: .error
            )

            if supportedRegions == ["US"] {
                invalidRegion.title = L.title
                invalidRegion.message = L.messageUs(appName)
            } else if supportedRegions.count <= 5 {
                invalidRegion.message = L.messageFew(appName, supportedRegions.joined(separator: ", "))
            }

            throw invalidRegion
        }
    }
}

// MARK: - Delegate

extension LiveAddressSearchClient {
    private final class Delegate: NSObject, MKLocalSearchCompleterDelegate {
        fileprivate let searchCompleter = MKLocalSearchCompleter()
        private let onResults: ([AddressSearchResult]) -> Void

        init(onResults: @escaping ([AddressSearchResult]) -> Void) {
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
        // Extracting the city from the formatted address lines because "sublocality"
        // or "locality" are not uniquely identifying the proper city.
        //
        // For example, Brooklyn comes as a "sublocality" but Miami Beach comes as
        // "locality", and Long Island City doesn't come in neither of these properties.
        //
        // However, formatted address lines returns the correct data (e.g., "Brooklyn,
        // NY 11217"), we are parsing the string and taking the first component,
        // returning "Brooklyn" correctly as the city.
        //
        // We have to check the number of lines on the address as to know where to fetch
        // the city from: when 4 lines (address with apt number) are present the city is
        // in position #2. If only 3 lines, then the city is in position #1.
        //
        // If the address has 4 lines then we use position #1 to fill `address2`.
        //
        // ```swift
        // FormattedAddressLines = (
        //     "222 Jackson St",
        //     "Unit 5",
        //     "Brooklyn, NY 11211",
        //     "United States"
        // )
        // ```
        let addressLines = item.addressDictionary?["FormattedAddressLines"] as? [String] ?? []

        func getCityField(_ addressLines: [String]) -> String? {
            // Only one field means we only have the country
            guard addressLines.count > 1 else {
                return ""
            }

            // City field is located on the 2nd to last position
            return addressLines.at(addressLines.count - 2)
        }

        let city = getCityField(addressLines)?
            .components(separatedBy: ",")
            .first ?? ""

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
