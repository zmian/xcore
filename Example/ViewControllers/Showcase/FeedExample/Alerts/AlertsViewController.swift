//
// AlertsViewController.swift
//
// Copyright © 2019 Xcore
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

import UIKit

final class AlertsViewController: XCComposedCollectionViewController {
    private var sources = [FeedDataSource]()

    private let severalAlerts = [
        "Attend this place",
        "You have this to take care please take care of it!",
        "These is a long long message that has a lot of tasks lalsasd asdasd\nYou have this to take care please take care of it!\nLong Long Long"
    ]

    private let twoAlerts = [
        "First Alert",
        "Second alert"
    ]

    private let manyAlerts = [
        "This Alert",
        "Second alert",
        "First Alert",
        "Second alert",
        "First Alert",
        "Second alert",
        "First Alert",
        "Second alert",
        "First Alert",
        "Second alert"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = view.safeAreaInsets.top
        layout = .init(XCCollectionViewTileLayout())
    }

    override func dataSources(for collectionView: UICollectionView) -> [XCCollectionViewDataSource] {
        var allDataSources = [XCCollectionViewDataSource]()

        for i in 0...2 {
            allDataSources.append(FeedDataSource(collectionView: collectionView, sectionIndex: i))
        }
        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "FirstAlerts",
                alerts: severalAlerts
            )
        ))

        for i in 3...6 {
            allDataSources.append(FeedDataSource(collectionView: collectionView, sectionIndex: i))
        }
        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "SecondAlerts",
                alerts: manyAlerts
            )
        ))

        for i in 7...10 {
            allDataSources.append(FeedDataSource(collectionView: collectionView, sectionIndex: i))
        }
        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "ThirdAlerts",
                composedAlerts: [twoAlerts, twoAlerts]
            )
        ))

        return allDataSources
    }

    private func alertsDataSource(viewModel: AlertsViewModel) -> StackingDataSource {
        let cellProvider: StackingDataSource.CellProvider = { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as FeedTextViewCell
            guard let alertMessage = item as? String else {
                return cell
            }
            cell.configure(
                title: "\(indexPath.section)",
                subtitle: alertMessage
            )
            return cell
        }
        return StackingDataSource(
            collectionView: collectionView,
            viewModel: viewModel,
            cellProvider: cellProvider
        )
    }
}

private class AlertsViewModel: StackingDataSourceViewModel {
    var tileIdentifier: String = ""
    var composedAlerts: [[String]]

    convenience init(identifier: String, alerts: [String]) {
        self.init(identifier: identifier, composedAlerts: alerts.map { [$0] })
    }

    init(identifier: String, composedAlerts: [[String]]) {
        self.tileIdentifier = identifier
        self.composedAlerts = composedAlerts
    }

    public var numberOfSections: Int {
        return composedAlerts.count
    }

    public func itemsCount(for section: Int) -> Int {
        return composedAlerts.at(section)?.count ?? 0
    }

    func item(at index: IndexPath) -> Any? {
        composedAlerts.at(index.section)?.at(index.row)
    }

    private var didChange: (() -> Void)?
    func didChange(_ callback: @escaping () -> Void) {
        didChange = callback
    }

    func didTap(at index: IndexPath) {
    }

    var isShadowEnabled: Bool {
        return true
    }

    var isClearButtonHidden: Bool {
        isEmpty
    }

    func clearAll() {
        composedAlerts.removeAll()
        didChange?()
    }

    var clearButtonTitle: String {
        "Clear"
    }

    var showLessButtonTitle: String {
        "Show Less"
    }
}
