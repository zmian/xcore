//
// TestCase.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import UIKit
@testable import Example

class TestCase: XCTestCase {
    let application = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application.launchArguments.append("--uitesting")
        application.launch()
    }

    override func tearDown() {
        super.tearDown()
    }
}
