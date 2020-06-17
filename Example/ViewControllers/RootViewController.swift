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
            ),
            Section(
                title: "Pickers",
                detail: "A demonstration of pickers included in Xcore.",
                items: pickers()
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
            .init(title: "Buttons", subtitle: "UIButton extensions demonstration") { [weak self] _, _ in
                let vc = ButtonsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            .init(title: "TextViewController", subtitle: "TextViewController demonstration") { [weak self] _, _ in
                let vc = ExampleTextViewController()
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

    private func pickers() -> [DynamicTableModel] {
        [
            .init(title: "DatePicker", subtitle: "Date picker demonstration, selected value yesterday") { _, _ in
                let yesterday = Date(timeIntervalSinceNow: -3600 * 24)
                Picker.present(initialValue: yesterday) { date in
                    print("The selected date is \(date ?? Date())")
                }
            },
            .init(title: "Options Representable Picker", subtitle: "Using Picker to select from an options enum") { _, _ in
                Picker.present(selected: ExampleArrowOptions.allCases.first) { option in
                    print("Selected: \(option)")
                }
            },
            .init(title: "Drawer Screen", subtitle: "Dynamic Table View inside Drawer Screen") { _, _ in
                let vc = DynamicTableViewController(style: .plain)
                vc.didLoadView {
                    $0.view.backgroundColor = .clear
                }
                vc.tableView.sections = [
                    Section(items: [
                        DynamicTableModel(title: "Option 1", subtitle: "FeedViewController demonstration") { _, _ in
                            let model = ExamplePickerListModel()
                            let list = Picker.List(model: model).apply {
                                $0.reloadAnimation = .none
                            }
                            list.present()
                        },
                        DynamicTableModel(title: "Option 2", subtitle: "FeedViewController demonstration"),
                        DynamicTableModel(title: "Option 3", subtitle: "FeedViewController demonstration"),
                        DynamicTableModel(title: "Option 4", subtitle: "FeedViewController demonstration"),
                        DynamicTableModel(title: "Option 5", subtitle: "FeedViewController demonstration")
                    ])
                ]
                vc.view.snp.makeConstraints { make in
                    make.height.equalTo(300)
                }
                DrawerScreen.present(vc.view)
            },
            .init(title: "Picker List: Options Representable", subtitle: "Using Picker to select from an options enum") { _, _ in
                Picker.List.present(selected: ExampleArrowOptions.allCases.first) { option in
                    print("Selected: \(option)")
                }
            },
            .init(title: "Picker List: Strings. SelectionStyle: highlight", subtitle: "Using Picker to select from an array of strings") { _, _ in
                let items = 50.map {
                    "Option \($0)"
                }

                let middleItem = items[items.count / 2]

                Picker.List.present(
                    items,
                    selected: middleItem,
                    configure: {
                        $0.selectionStyle = .highlight(color: .yellow)
                    },
                    didSelect: { selected in
                        print("Selected: \(selected)")
                    }
                )
            },
            .init(title: "Picker List: Strings. SelectionStyle: Checkmark", subtitle: "Using Picker to select from an array of strings") { _, _ in
                let items = 10.map {
                    "Option \($0)"
                }

                let middleItem = items[items.count / 2]

                Picker.List.present(
                    items,
                    selected: middleItem,
                    configure: {
                        $0.selectionStyle = .checkmark
                    },
                    didSelect: { selected in
                        print("Selected: \(selected)")
                    }
                )
            },
            .init(title: "Picker List: Timer", subtitle: "Dynamic Table View inside Drawer Screen configured using a view-model") { _, _ in
                let model = ExamplePickerListModel()
                let list = Picker.List(model: model).apply {
                    $0.reloadAnimation = .none
                    $0.isToolbarHidden = true
                }
                list.present()
            },
            .init(title: "Picker List: Really long text", subtitle: "Picker with really long text") { _, _ in
                let items = 3.map {
                    "\($0). Although it wasn’t added to the collection until the 18th century by French scholar Antoine Galland, ‘Aladdin’ is one of the most popular tales from 1,001 Nights because of its modern Disney adaptation. In the original tale, Aladdin is a poor, young man in ‘one of the cities of China.’ A sorcerer deceives Aladdin and persuades him to steal an oil lamp from a magic cave. Aladdin accidentally releases a genie from the lamp, and so a series of events unfold in which Aladdin’s every wish comes true, but only to be dismantled by the villain. Thankfully, a Disney-approved happy ending is in store."
                }

                Picker.List.present(items) { selected in
                    print("Selected: \(selected)")
                }
            },
            .init(title: "Picker List: Really long text with Selected", subtitle: "Picker with really long text") { _, _ in
                let items = 3.map {
                    "\($0). Although it wasn’t added to the collection until the 18th century by French scholar Antoine Galland, ‘Aladdin’ is one of the most popular tales from 1,001 Nights because of its modern Disney adaptation. In the original tale, Aladdin is a poor, young man in ‘one of the cities of China.’ A sorcerer deceives Aladdin and persuades him to steal an oil lamp from a magic cave. Aladdin accidentally releases a genie from the lamp, and so a series of events unfold in which Aladdin’s every wish comes true, but only to be dismantled by the villain. Thankfully, a Disney-approved happy ending is in store."
                }

                let middleItem = items[items.count / 2]

                Picker.List.present(items, selected: middleItem) { selected in
                    print("Selected: \(selected)")
                }
            }
        ]
    }
}
