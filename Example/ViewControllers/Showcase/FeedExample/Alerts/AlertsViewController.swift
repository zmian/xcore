//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
        view.backgroundColor = .systemGroupedBackground
        collectionView.backgroundColor = .clear
        layout = .init(XCCollectionViewTileLayout())
    }

    override func dataSources() -> [XCCollectionViewDataSource] {
        var allDataSources = [XCCollectionViewDataSource]()

        for i in 0...2 {
            allDataSources.append(FeedDataSource(sectionIndex: i))
        }
        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "FirstAlerts",
                items: severalAlerts
            )
        ))

        for i in 3...6 {
            allDataSources.append(FeedDataSource(sectionIndex: i))
        }

        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "SecondAlerts",
                items: manyAlerts
            )
        ))

        for i in 7...10 {
            allDataSources.append(FeedDataSource(sectionIndex: i))
        }

        allDataSources.append(alertsDataSource(
            viewModel: AlertsViewModel(
                identifier: "ThirdAlerts",
                items: [twoAlerts, twoAlerts]
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
            viewModel: viewModel,
            cellProvider: cellProvider
        )
    }
}

private class AlertsViewModel: StackingDataSourceViewModel {
    var tileIdentifier: String = ""
    var items: [[String]]

    convenience init(identifier: String, items: [String]) {
        self.init(identifier: identifier, items: items.map { [$0] })
    }

    init(identifier: String, items: [[String]]) {
        self.tileIdentifier = identifier
        self.items = items
    }

    public var numberOfSections: Int {
        items.count
    }

    public func itemsCount(for section: Int) -> Int {
        items.at(section)?.count ?? 0
    }

    func item(at index: IndexPath) -> Any? {
        items.at(index.section)?.at(index.row)
    }

    private var didChange: (() -> Void)?
    func didChange(_ callback: @escaping () -> Void) {
        didChange = callback
    }

    func didTap(at index: IndexPath) { }

    var isShadowEnabled: Bool {
        false
    }

    var isClearButtonHidden: Bool {
        isEmpty
    }

    func clearAll() {
        items.removeAll()
        didChange?()
    }

    var clearButtonTitle: String {
        "Clear"
    }

    var showLessButtonTitle: String {
        "Show Less"
    }
}
