//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
internal import MapKit

// MARK: - Dot Syntax Support

extension AddressSearchClient where Self == LiveAddressSearchClient {
    /// Returns the live variant of `AddressSearchClient`.
    public static var live: Self {
        .init()
    }
}

extension LiveAddressSearchClient {
    /// A list of ISO country codes for supported regions (e.g., “US” or “GB”).
    ///
    /// If empty then all regions are supported.
    nonisolated(unsafe) public static var supportedRegions = [Locale.Region.unitedStates]
}

// MARK: - Implementation

public final class LiveAddressSearchClient: AddressSearchClient {
    private typealias L = Localized.PostalAddress
    private let delegates = LockIsolated([UUID: Delegate]())

    public func query(_ query: String) async throws -> PostalAddress {
        let request = MKLocalSearch.Request().apply {
            $0.naturalLanguageQuery = query
            $0.resultTypes = .address
        }

        let mapItem = try await perform(request: request)
        return PostalAddress(mapItem)
    }

    public func updateQuery(_ query: String, id: UUID) {
        delegates.withValue {
            $0[id]?.query = query
        }
    }

    public func resolve(_ result: AddressSearchResult) async throws -> PostalAddress {
        let mapItem = try await perform(request: result.request())
        return PostalAddress(mapItem)
    }

    public func validate(_ address: PostalAddress) async throws {
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

        let mapItem = try await perform(request: request)

        // Check the result address corresponds to US. We check this here to avoid users
        // from selecting US as country but entering details of an address from a
        // different country.
        try supportedRegionValidation(mapItem.addressRepresentations?.region?.identifier)
    }

    public func observe(id: UUID) -> AsyncStream<[AddressSearchResult]> {
        AsyncStream { [weak self] continuation in
            self?.delegates.withValue {
                $0[id] = Delegate { results in
                    continuation.yield(results)
                }
            }

            continuation.onTermination = { [weak self] _ in
                self?.delegates.withValue {
                    $0[id] = nil
                }
            }
        }
    }

    /// Performs a request to the maps API to obtain a map item.
    private func perform(request: MKLocalSearch.Request) async throws -> MKMapItem {
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()

            if let mapItem = response.mapItems.first {
                return mapItem
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
    private final class Delegate: NSObject, MKLocalSearchCompleterDelegate, Sendable {
        nonisolated(unsafe) private let searchCompleter = MKLocalSearchCompleter()
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

        var query: String {
            get { searchCompleter.queryFragment }
            set { searchCompleter.queryFragment = newValue }
        }

        deinit {
            searchCompleter.cancel()
        }
    }
}

// MARK: - Helpers

extension PostalAddress {
    init(_ item: MKMapItem) {
        func isSecondaryAddressLine(_ line: String) -> Bool {
            line.validate(
                rule: .regex(
                    "(?i)^(?:apt\\.?|apartment|unit|suite|ste\\.?|floor|fl\\.?|room|rm\\.?|building|bldg\\.?|#)\\s*\\S+.*$"
                )
            )
        }

        let representations = item.addressRepresentations
        let postalAddress = item.placemark.postalAddress
        let postalStreet = postalAddress?.street
        let state = postalAddress?.state
        let postalCode = postalAddress?.postalCode
        let city = representations?.cityName
        let regionName = representations?.regionName
        let regionCode = representations?.region?.identifier

        let contextValues = [city, state, postalCode, regionName, regionCode]
            .compactMap { $0?.trimmed() }
            .filter { !$0.isBlank }

        let lines: [String] = {
            let postalStreetLines = postalStreet?
                .lines()
                .map { $0.trimmed() }
                .filter { !$0.isBlank } ?? []

            if !postalStreetLines.isEmpty {
                return postalStreetLines
            }

            var formattedLines = (representations?.fullAddress(includingRegion: false, singleLine: false) ?? item.address?.fullAddress)?
                .lines()
                .map { $0.trimmed() }
                .filter { !$0.isBlank } ?? []

            func isContextLine(_ line: String) -> Bool {
                let line = line.trimmed()

                guard !line.isBlank else {
                    return true
                }

                return contextValues.contains { token in
                    if token.count <= 3 {
                        let pattern = "(?i)(?:^|[^[:alnum:]])\(NSRegularExpression.escapedPattern(for: token))(?:$|[^[:alnum:]])"
                        return line.validate(rule: .regex(pattern))
                    }

                    return line.contains(token, options: [.caseInsensitive, .diacriticInsensitive])
                }
            }

            while let last = formattedLines.last, isContextLine(last) {
                formattedLines.removeLast()
            }

            if formattedLines.isEmpty, let shortAddress = item.address?.shortAddress, !isContextLine(shortAddress) {
                return [shortAddress]
            }

            return formattedLines
        }()
        let street2 = lines.dropFirst().first.map { isSecondaryAddressLine($0) ? $0 : "" } ?? ""

        self.init(
            street1: postalStreet ?? "",
            street2: street2,
            city: city ?? "",
            state: state ?? "",
            postalCode: postalCode ?? "",
            countryCode: regionCode ?? ""
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
