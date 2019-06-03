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
            )
        ]
    }

    private func items() -> [DynamicTableModel] {
        return [
            DynamicTableModel(title: "Dynamic Table View", subtitle: "Data-driven table view", accessory: .disclosureIndicator) { [weak self] _, _ in
                let vc = ExampleDynamicTableViewController()
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
            DynamicTableModel(title: "FeedViewController", subtitle: "TextViewController demonstration") { [weak self] _, _ in
                let vc = FeedViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ]
    }
}
