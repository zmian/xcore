//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class RootViewController: DynamicTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sections = [
            Section(
                title: "Components",
                detail: "A demonstration of components included in Xcore.",
                items: items()
            )
        ]

        tableView.configureCell { indexPath, cell, item in
            cell.highlightedBackgroundColor = .appHighlightedBackground
        }
    }

    private func items() -> [DynamicTableModel] {
        [
            .init(title: "Dynamic Table View", subtitle: "Data-driven table view", accessory: .disclosureIndicator) { [weak self] _, _ in
                let vc = ExampleDynamicTableViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "Separators", subtitle: "Separators demonstration") { [weak self] _, _ in
                let vc = SeparatorViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "Pickers", subtitle: "Pickers demonstration") { [weak self] _, _ in
                let vc = PickersViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "Buttons", subtitle: "UIButton extensions demonstration") { [weak self] _, _ in
                let vc = ButtonsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "FeedViewController", subtitle: "FeedViewController demonstration") { [weak self] _, _ in
                let vc = FeedViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "AlertsViewController", subtitle: "Tiled alerts Demostration") { [weak self] _, _ in
                let vc = AlertsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "Carousel View Controller", subtitle: "Carousel demonstration") { [weak self] _, _ in
                let vc = CarouselViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "Label Inset", subtitle: "Label with different `contentInset` setup (Xcore extension)") { [weak self] _, _ in
                let vc = ExampleLabelInsetViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ]
    }
}
