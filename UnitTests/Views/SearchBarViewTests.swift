//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import Combine
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

// MARK: - Mock

private final class MockSearchBarView: XCView {
    fileprivate let searchBarView = SearchBarView()
    private var originalItems = Array(0..<100)
    private let searchBar = UISearchBar()
    private var cancellable: AnyCancellable?

    var displayedItems = Array(0..<100)

    override func commonInit() {
        searchBarView.placeholder = "Search"

        cancellable = searchBarView.actionPublisher.sink { [weak self] action in
            guard let strongSelf = self else {
                return
            }

            switch action {
                case let .didChangeText(searchText):
                    if let searchNumber = Int(searchText) {
                        strongSelf.displayedItems = strongSelf.originalItems.filter { $0 == searchNumber }
                        return
                    }

                    if searchText.isEmpty {
                        strongSelf.displayedItems = strongSelf.originalItems
                    }
                default:
                    break
            }
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
