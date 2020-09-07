//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class SubviewLookupTests: ViewControllerTestCase {
    func testSubview() {
        let searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.layoutIfNeeded()

        XCTAssertNotNil(searchBar.firstSubview(withClass: UITextField.self))
        XCTAssertNotNil(searchBar.firstSubview(withClassName: "UISearchBarTextField"))

        XCTAssertNil(searchBar.firstSubview(withClass: UITextField.self, comparison: .typeOf))
        XCTAssertNotNil(searchBar.firstSubview(withClass: UITextField.self, comparison: .kindOf))
        XCTAssertNotNil(searchBar.firstSubview(withClassName: "UISearchBarTextField", comparison: .typeOf))
        XCTAssertNotNil(searchBar.firstSubview(withClassName: "UISearchBarTextField", comparison: .kindOf))
    }

    func testSearchBar() {
        let searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.layoutIfNeeded()

        searchBar.placeholder = "Hello, World!"
        XCTAssertEqual(searchBar.placeholder, "Hello, World!")
    }
}
