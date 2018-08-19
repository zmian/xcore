//
// ExampleDynamicTableViewController.swift
//
// Copyright © 2016 Zeeshan Mian
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
import Xcore

final class ExampleDynamicTableViewController: DynamicTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(DynamicTableView.self)"

        tableView.cellOptions = [.delete]

        tableView.sections = [
            Section(
                title: "Section 1",
                detail: "Important notice about the footer can be displayed here.",
                items: [
                    DynamicTableModel(title: "Hummingbird", subtitle: "Hummingbirds are New World birds that constitute the family Trochilidae. They are among the {#ff0000|smallest of birds}, most species measuring in the 7.5–13 cm range.")
                ]
            ),
            Section(
                title: "Birds",
                items: [
                    DynamicTableModel(title: "Hummingbird", subtitle: "Hummingbirds are New World birds that constitute the family Trochilidae. They are among the {#ff0000|smallest of birds}, most species measuring in the 7.5–13 cm range."),
                    DynamicTableModel(title: "Hummingbird", image: R(.blueJay)),
                    DynamicTableModel(title: "Hummingbird", image: R(.blueJay), accessory: .disclosureIndicator),
                    DynamicTableModel(subtitle: "**You** are now a **confirmed bird watcher** with 70 birds spotted!"),
                    DynamicTableModel(title: "Showcase", subtitle: "This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}", image: R(.blueJay)),
                    DynamicTableModel(title: "Showcase", subtitle: "This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}. This string has **bold**, //italics//, and {#ff0000|red text}", image: R(.blueJay)),
                    DynamicTableModel(title: "Woodpecker", accessory: .disclosureIndicator),
                    DynamicTableModel(title: "Blue Jay", accessory: .text("462")),
                    DynamicTableModel(title: "1,223", subtitle: "Globally, 1,223 species of birds", image: R(.blueJay), accessory: .text("5m")),
                    DynamicTableModel(title: "American Goldfinch", subtitle: "Spinus tristis", image: R(.blueJay), accessory: DynamicTableAccessoryType.checkbox(isSelected: true) { sender -> Void in
                        let choice = sender.isSelected ? "On" : "Off"
                        print("American Goldfinch \(choice)")
                    }),
                    DynamicTableModel(title: "Woodpecker", subtitle: "200 Species", accessory: DynamicTableAccessoryType.checkbox(isSelected: true) { sender -> Void in
                        let choice = sender.isSelected ? "On" : "Off"
                        print("Woodpecker \(choice)")
                    }),
                    DynamicTableModel(title: "Woodpecker", subtitle: "200 Species", accessory: DynamicTableAccessoryType.switch(isOn: true) { sender -> Void in
                        let choice = sender.isOn ? "On" : "Off"
                        print("Woodpecker \(choice)")
                    }),
                    DynamicTableModel(title: "Cardinal", subtitle: "Cardinalidae, Passerine"),
                    DynamicTableModel(title: "Blue Jay", subtitle: "Cyanocitta Cristata • Cyanocitta", image: R(.blueJay))
                ]
            )
        ]

        tableView.configureCell { indexPath, cell, item in
            if indexPath.row == 1 {
                cell.isImageViewRounded = true
            }

            if indexPath.row == 5 {
                cell.imageSize = CGSize(width: 30, height: 30)
            }
        }

        tableView.didSelectItem { indexPath, item in
            print("DidSelectItemAt: \(item.title != nil ? item.title!.stringSource.rawValue : "")")
        }

        tableView.didRemoveItem { indexPath, item in
            print("DidRemoveItemAt: \(item.title != nil ? item.title!.stringSource.rawValue : "")")
        }
    }
}
