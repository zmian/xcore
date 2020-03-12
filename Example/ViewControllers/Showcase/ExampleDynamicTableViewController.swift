//
// ExampleDynamicTableViewController.swift
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

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
                    .init(title: "Hummingbird", subtitle: "Hummingbirds are New World birds that constitute the family Trochilidae. They are among the {#ff0000|smallest of birds}, most species measuring in the 7.5–13 cm range.")
                ]
            ),
            Section(
                title: "Birds",
                items: [
                    .init(title: "Hummingbird", subtitle: "Hummingbirds are New World birds that constitute the family Trochilidae. They are among the {#ff0000|smallest of birds}, most species measuring in the 7.5–13 cm range."),
                    .init(title: "Hummingbird", image: r(.blueJay)),
                    .init(title: "Hummingbird", image: r(.blueJay), accessory: .disclosureIndicator),
                    .init(subtitle: "**You** are now a **confirmed bird watcher** with 70 birds spotted!"),
                    .init(title: "Showcase", subtitle: "This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}", image: r(.blueJay)),
                    .init(title: "Showcase", subtitle: "This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}. This string has **bold**, _italics_, and {#ff0000|red text}", image: r(.blueJay)),
                    .init(title: "Woodpecker", accessory: .disclosureIndicator),
                    .init(title: "Blue Jay", accessory: .text("462")),
                    .init(title: "1,223", subtitle: "Globally, 1,223 species of birds", image: r(.blueJay), accessory: .text("5m")),
                    .init(title: "American Goldfinch", subtitle: "Spinus tristis", image: r(.blueJay), accessory: ListAccessoryType.checkbox(isSelected: true) { sender -> Void in
                        let choice = sender.isSelected ? "On" : "Off"
                        print("American Goldfinch \(choice)")
                    }),
                    .init(title: "Woodpecker", subtitle: "200 Species", accessory: ListAccessoryType.checkbox(isSelected: true) { sender -> Void in
                        let choice = sender.isSelected ? "On" : "Off"
                        print("Woodpecker \(choice)")
                    }),
                    .init(title: "Woodpecker", subtitle: "200 Species", accessory: ListAccessoryType.toggle(isOn: true) { sender -> Void in
                        let choice = sender.isOn ? "On" : "Off"
                        print("Woodpecker \(choice)")
                    }),
                    .init(title: "Cardinal", subtitle: "Cardinalidae, Passerine"),
                    .init(title: "Blue Jay", subtitle: "Cyanocitta Cristata • Cyanocitta", image: r(.blueJay))
                ]
            )
        ]

        tableView.configureCell { indexPath, cell, item in
            cell.avatarView.apply {
                $0.isContentModeAutomaticallyAdjusted = false
                $0.contentMode = .scaleAspectFill
            }

            if indexPath.row == 1 {
                cell.isImageViewRounded = true
            }

            if indexPath.row == 5 {
                cell.imageSize = CGSize(width: 30, height: 30)
            }
        }

        tableView.didSelectItem { indexPath, item in
            print("DidSelectItemAt: \(item.title != nil ? item.title!.stringSource.description : "")")
        }

        tableView.didRemoveItem { indexPath, item in
            print("DidRemoveItemAt: \(item.title != nil ? item.title!.stringSource.description : "")")
        }
    }
}
