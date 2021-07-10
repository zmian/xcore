//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class SourceContextTests: TestCase {
    func testOutput() {
        let context = SourceContext()
        let fileId = "XcoreTests/SourceContextTests.swift"
        let function = "testOutput()"
        let line: UInt = 12
        let column: UInt = 36

        let description = """
        file:     "\(context.file)"
        fileId:   "\(context.fileId)"
        filePath: "\(context.filePath)"
        function: "\(context.function)"
        line:     \(context.line)
        column:   \(context.column)
        """

        XCTAssertEqual("\(context.file)", "\(context.filePath)")
        XCTAssertTrue("\(context.file)".hasSuffix(fileId))
        XCTAssertEqual("\(context.fileId)", fileId)
        XCTAssertEqual("\(context.function)", function)
        XCTAssertEqual(context.line, line)
        XCTAssertEqual(context.column, column)
        XCTAssertEqual(context.class, "SourceContextTests")
        XCTAssertEqual("\(context)", description)
    }
}
