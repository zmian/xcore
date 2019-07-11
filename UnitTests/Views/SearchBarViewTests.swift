//
// SearchBarViewTests.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
@testable import Xcore

final class SearchBarViewTests: ViewControllerTestCase {
    func testSearchBarView() {
        let searchBarView = MockSearchBarView()
        view.addSubview(searchBarView)
        searchBarView.layoutIfNeeded()

        searchBarView.searchBarView.placeholder = "Hello, World!"
        XCTAssertEqual(searchBarView.searchBarView.placeholder, "Hello, World!")

        // Test typing
        searchBarView.searchString = "99"
        XCTAssertEqual(searchBarView.displayedItems.count, 1)
        XCTAssertEqual(searchBarView.displayedItems, [99])
        searchBarView.tapCancelButton()
        XCTAssertEqual(searchBarView.displayedItems.count, 100)

        // Test typing and deleting
        searchBarView.searchString = "99"
        XCTAssertEqual(searchBarView.displayedItems, [99])
        searchBarView.searchString = "9"
        XCTAssertEqual(searchBarView.displayedItems, [9])
        searchBarView.searchString = ""
        XCTAssertEqual(searchBarView.displayedItems, Array(0..<100))
    }
}

private final class MockSearchBarView: XCView {
    fileprivate let searchBarView = SearchBarView()
    private var originalItems = Array(0..<100)
    private let searchBar = UISearchBar()

    var displayedItems = Array(0..<100)

    override func commonInit() {
        searchBarView.placeholder = "Search"

        searchBarView.didChangeText { [weak self] searchText in
            guard let strongSelf = self else {
                return
            }

            if let searchNumber = Int(searchText) {
                strongSelf.displayedItems = strongSelf.originalItems.filter { $0 == searchNumber }
                return
            }

            if searchText.isEmpty {
                strongSelf.displayedItems = strongSelf.originalItems
            }
        }

        searchBarView.didTapCancel { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.displayedItems = strongSelf.originalItems
        }

        addSubview(searchBarView)
        searchBarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    var searchString: String = "" {
        didSet {
            searchBarView.searchBar(searchBar, textDidChange: searchString)
        }
    }

    func tapCancelButton() {
        searchBarView.searchBarCancelButtonClicked(searchBar)
    }
}
