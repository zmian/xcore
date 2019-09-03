//
// RootViewController.swift
//
// Copyright © 2014 Xcore
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
    }

    private func items() -> [DynamicTableModel] {
        return [
            DynamicTableModel(title: "Dynamic Table View", subtitle: "Data-driven table view", accessory: .disclosureIndicator) { [weak self] _, _ in
                let vc = ExampleDynamicTableViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            DynamicTableModel(title: "Separators", subtitle: "Separators demonstration") { [weak self] _, _ in
                let vc = SeparatorViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            DynamicTableModel(title: "Buttons", subtitle: "UIButton extensions demonstration") { [weak self] _, _ in
                let vc = ButtonsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            DynamicTableModel(title: "TextViewController", subtitle: "TextViewController demonstration") { [weak self] _, _ in
                let vc = ExampleTextViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            DynamicTableModel(title: "FeedViewController", subtitle: "FeedViewController demonstration") { [weak self] _, _ in
                let vc = FeedViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ]
    }

    private func pickers() -> [DynamicTableModel] {
        return [
            DynamicTableModel(title: "DatePicker", subtitle: "Date picker demonstration, selected value yesterday") { _, _ in
                let yesterday = Date(timeIntervalSinceNow: -3600 * 24)
                DatePicker.present(initialValue: yesterday) { date in
                    print("The selected date is \(date ?? Date())")
                }
            },
            DynamicTableModel(title: "Options Representable Picker", subtitle: "Using Picker to select from an options enum") { _, _ in
                Picker.present(selected: ExampleArrowOptions.allCases.first) { option in
                    print("Did select \(option)")
                }
            },
            DynamicTableModel(title: "Drawer Screen", subtitle: "Dynamic Table View inside Drawer Screen") { _, _ in
                let vc = DynamicTableViewController(style: .plain)
                vc.tableView.sections = [
                    Section(items: [
                        DynamicTableModel(title: "Option 1", subtitle: "FeedViewController demonstration") { _, _ in
                            print("Selected model!!")
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
            }
        ]
    }
}
