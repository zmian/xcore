//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

final class SubviewLookupTests: ViewControllerTestCase {
    @Test
    func subview() {
        let searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.layoutIfNeeded()

        #expect(searchBar.firstSubview(withClass: UITextField.self) != nil )
        #expect(searchBar.firstSubview(withClassName: "UISearchBarTextField") != nil)

        #expect(searchBar.firstSubview(withClass: UITextField.self, comparison: .typeOf) == nil)
        #expect(searchBar.firstSubview(withClass: UITextField.self, comparison: .kindOf) != nil)
        #expect(searchBar.firstSubview(withClassName: "UISearchBarTextField", comparison: .typeOf) != nil)
        #expect(searchBar.firstSubview(withClassName: "UISearchBarTextField", comparison: .kindOf) != nil)
    }

    @Test
    func searchBar() {
        let searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.layoutIfNeeded()

        searchBar.placeholder = "Hello, World!"
        #expect(searchBar.placeholder == "Hello, World!")
    }
}
