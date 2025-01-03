//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable empty_string

import Testing
@testable import Xcore

@Suite(.serialized)
struct LiveAddressSearchClientTests {
    init() {
        LiveAddressSearchClient.supportedRegions = [.unitedStates]
    }

    @Test
    func queensAddresses() async {
        // No Country
        await search("3818 Queens Blvd, Queens, NY 11101") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }

        await search("38-18 Queens Blvd, Long Island City, NY 11101") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }

        // With country
        await search("3818 Queens Blvd, Queens, NY 11101, United States") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }

        await search("38-18 Queens Blvd, Long Island City, NY 11101, USA") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }

        // No zip code
        await search("3818 Queens Blvd, Long Island City, NY") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }

        // No zip code with Country
        await search("3818 Queens Blvd, Long Island City, NY, USA") { postalAddress in
            #expect(postalAddress.street1 == "38-18 Queens Blvd")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Long Island City")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11101")
            #expect(postalAddress.countryCode == "US")
        }
    }

    @Test
    func normalAddress() async {
        await search("529 Broadway, 10B, New York, NY 10012, United States") { postalAddress in
            #expect(postalAddress.street1 == "529 Broadway")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "New York")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "10012")
            #expect(postalAddress.countryCode == "US")
        }

        await search("2761 Raging River Ct, Decatur, GA  30034, United States") { postalAddress in
            #expect(postalAddress.street1 == "2761 Raging River Ct")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Decatur")
            #expect(postalAddress.state == "GA")
            #expect(postalAddress.postalCode == "30034")
            #expect(postalAddress.countryCode == "US")
        }
    }

    @Test
    func incompleteAddress() async {
        await search("Nothing, Decatur, GA 30034, US") { postalAddress in
            #expect(postalAddress.street1 == "")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Decatur")
            #expect(postalAddress.state == "GA")
            #expect(postalAddress.postalCode == "30034")
            #expect(postalAddress.countryCode == "US")
        }

        await search("123 Havenshire Ridge Ln, Pinehurst TX 77362") { postalAddress in
            #expect(postalAddress.street1 == "Havenshire Ridge Ln")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Pinehurst")
            #expect(postalAddress.state == "TX")
            #expect(postalAddress.postalCode == "77362")
            #expect(postalAddress.countryCode == "US")
        }
    }

    @Test
    func nonUsaAddresses() async {
        await search("Carrera de San Jeronimo, 34, Madrid 28014") { postalAddress in
            #expect(postalAddress.street1 == "34 Carrera de San Jerónimo")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Centro")
            #expect(postalAddress.state == "Madrid")
            #expect(postalAddress.postalCode == "28014")
            #expect(postalAddress.countryCode == "ES")

            let client = Dependency(\.addressSearch).wrappedValue

            // 1. Default Supported Regions
            // ============================

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    #expect(error.id == "address_validation_failed_invalid_region")
                    #expect(error.title == "U.S. Addresses")
                    #expect(error.message == "xctest is currently available to U.S. residents. To continue, please enter your U.S. residential address.")
                    #expect(error.logLevel == .error)
                } else {
                    Issue.record("Unexpected error type")
                }
            }

            // 2. Spain as Supported Regions
            // =============================

            LiveAddressSearchClient.supportedRegions = [.unitedStates, .spain]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                Issue.record("Spain is a supported region")
            }

            // 3. Portugal as Supported Regions
            // ================================

            LiveAddressSearchClient.supportedRegions = [.portugal]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    #expect(error.id == "address_validation_failed_invalid_region")
                    #expect(error.title == "Portugal Addresses")
                    #expect(error.message == "xctest is currently available to Portugal residents. To continue, please enter your Portugal residential address.")
                    #expect(error.logLevel == .error)
                } else {
                    Issue.record("Unexpected error type")
                }
            }

            // 4. US, PT, and GB as Supported Regions
            // ======================================

            LiveAddressSearchClient.supportedRegions = [.unitedStates, .portugal, .unitedKingdom]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    #expect(error.id == "address_validation_failed_invalid_region")
                    #expect(error.title == "Unsupported Region")
                    #expect(error.message == "xctest is currently available to only US, PT, and GB residents. To continue, please enter your residential address in one of the supported regions.")
                    #expect(error.logLevel == .error)
                } else {
                    Issue.record("Unexpected error type")
                }
            }

            // 5. Supported in over 5 regions
            // ==============================

            LiveAddressSearchClient.supportedRegions = [.unitedStates, .portugal, .unitedKingdom, .australia, .newZealand, .turkey]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    #expect(error.id == "address_validation_failed_invalid_region")
                    #expect(error.title == "Unsupported Region")
                    #expect(error.message == "xctest is currently not available in your region.")
                    #expect(error.logLevel == .error)
                } else {
                    Issue.record("Unexpected error type")
                }
            }
        }
    }

    @Test
    func addressWithUnit() async {
        await search("222 Jackson St, Unit 5, Brooklyn, NY 11211") { postalAddress in
            #expect(postalAddress.street1 == "222 Jackson St")
            #expect(postalAddress.street2 == "Unit 5")
            #expect(postalAddress.city == "Brooklyn")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11211")
            #expect(postalAddress.countryCode == "US")
        }

        await search("222 Jackson St, Apt 5, Brooklyn, NY 11211") { postalAddress in
            #expect(postalAddress.street1 == "222 Jackson St")
            #expect(postalAddress.street2 == "Apt 5")
            #expect(postalAddress.city == "Brooklyn")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11211")
            #expect(postalAddress.countryCode == "US")
        }

        await search("222 Jackson St, 5, Brooklyn, NY 11211") { postalAddress in
            #expect(postalAddress.street1 == "222 Jackson St")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Brooklyn")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11211")
            #expect(postalAddress.countryCode == "US")
        }

        await search("2900 Bedford Ave, 2B, Brooklyn, NY 11210") { postalAddress in
            #expect(postalAddress.street1 == "2900 Bedford Ave")
            #expect(postalAddress.street2 == "")
            #expect(postalAddress.city == "Brooklyn")
            #expect(postalAddress.state == "NY")
            #expect(postalAddress.postalCode == "11210")
            #expect(postalAddress.countryCode == "US")
        }
    }
}

// MARK: - Helpers

extension LiveAddressSearchClientTests {
    private func search(
        _ query: String,
        sourceLocation: SourceLocation = #_sourceLocation,
        callback: (PostalAddress) async throws -> Void
    ) async {
        do {
            try await withDependencies {
                $0.addressSearch = .live
            } operation: {
                let client = Dependency(\.addressSearch).wrappedValue
                let postalAddress = try await client.search(query: query)
                try await callback(postalAddress)
            }
        } catch {
            Issue.record(error, sourceLocation: sourceLocation)
        }
    }
}
