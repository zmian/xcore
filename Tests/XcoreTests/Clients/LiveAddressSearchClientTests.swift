//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class LiveAddressSearchClientTests: TestCase {
    override func setUp() {
        super.setUp()
        LiveAddressSearchClient.supportedRegions = [.unitedStates]
    }

    func testQueensAddresses() async {
        // No Country
        await search("3818 Queens Blvd, Queens, NY 11101") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("38-18 Queens Blvd, Long Island City, NY 11101") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        // With country
        await search("3818 Queens Blvd, Queens, NY 11101, United States") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("38-18 Queens Blvd, Long Island City, NY 11101, USA") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        // No zip code
        await search("3818 Queens Blvd, Long Island City, NY") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        // No zip code with Country
        await search("3818 Queens Blvd, Long Island City, NY, USA") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "38-18 Queens Blvd")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Long Island City")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11101")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }
    }

    func testNormalAddress() async {
        await search("529 Broadway, 10B, New York, NY 10012, United States") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "529 Broadway")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "New York")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "10012")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("2761 Raging River Ct, Decatur, GA  30034, United States") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "2761 Raging River Ct")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Decatur")
            XCTAssertEqual(postalAddress.state, "GA")
            XCTAssertEqual(postalAddress.postalCode, "30034")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }
    }

    func testIncompleteAddress() async {
        await search("Nothing, Decatur, GA 30034, US") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Decatur")
            XCTAssertEqual(postalAddress.state, "GA")
            XCTAssertEqual(postalAddress.postalCode, "30034")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("123 Havenshire Ridge Ln, Pinehurst TX 77362") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "Havenshire Ridge Ln")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Pinehurst")
            XCTAssertEqual(postalAddress.state, "TX")
            XCTAssertEqual(postalAddress.postalCode, "77362")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }
    }

    func testNonUsaAddresses() async {
        await search("Carrera de San Jeronimo, 34, Madrid 28014") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "34 Carrera de San Jerónimo")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "28014 Madrid")
            XCTAssertEqual(postalAddress.state, "Madrid")
            XCTAssertEqual(postalAddress.postalCode, "28014")
            XCTAssertEqual(postalAddress.countryCode, "ES")

            let client = Dependency(\.addressSearch).wrappedValue

            // 1. Default Supported Regions
            // ============================

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    XCTAssertEqual(error.id, "address_validation_failed_invalid_region")
                    XCTAssertEqual(error.title, "U.S. Addresses")
                    XCTAssertEqual(error.message, "xctest is currently available to U.S. residents. To continue, please enter your U.S. residential address.")
                    XCTAssertEqual(error.logLevel, .error)
                } else {
                    XCTFail("Unexpected error type")
                }
            }

            // 2. Spain as Supported Regions
            // =============================
            LiveAddressSearchClient.supportedRegions = [.unitedStates, .spain]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                XCTFail("Spain is supported region")
            }

            // 3. US, PT, and GB as Supported Regions
            // ======================================

            LiveAddressSearchClient.supportedRegions = [.unitedStates, .portugal, .unitedKingdom]

            do {
                try await client.validate(address: postalAddress)
            } catch {
                if let error = error as? AppError {
                    XCTAssertEqual(error.id, "address_validation_failed_invalid_region")
                    XCTAssertEqual(error.title, "Unsupported Region")
                    XCTAssertEqual(error.message, "xctest is currently available to only US, PT, and GB residents. To continue, please enter your residential address in one of the supported regions.")
                    XCTAssertEqual(error.logLevel, .error)
                } else {
                    XCTFail("Unexpected error type")
                }
            }
        }
    }

    func testAddressWithUnit() async {
        await search("222 Jackson St, Unit 5, Brooklyn, NY 11211") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "222 Jackson St")
            XCTAssertEqual(postalAddress.street2, "Unit 5")
            XCTAssertEqual(postalAddress.city, "Brooklyn")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11211")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("222 Jackson St, Apt 5, Brooklyn, NY 11211") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "222 Jackson St")
            XCTAssertEqual(postalAddress.street2, "Apt 5")
            XCTAssertEqual(postalAddress.city, "Brooklyn")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11211")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("222 Jackson St, 5, Brooklyn, NY 11211") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "222 Jackson St")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Brooklyn")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11211")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }

        await search("2900 Bedford Ave, 2B, Brooklyn, NY 11210") { postalAddress in
            XCTAssertEqual(postalAddress.street1, "2900 Bedford Ave")
            XCTAssertEqual(postalAddress.street2, "")
            XCTAssertEqual(postalAddress.city, "Brooklyn")
            XCTAssertEqual(postalAddress.state, "NY")
            XCTAssertEqual(postalAddress.postalCode, "11210")
            XCTAssertEqual(postalAddress.countryCode, "US")
        }
    }
}

// MARK: - Helpers

extension LiveAddressSearchClientTests {
    private func search(
        _ query: String,
        file: StaticString = #file,
        line: UInt = #line,
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
            XCTFail(String(describing: error), file: file, line: line)
        }
    }
}
