//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct Menu: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String?
    let content: () -> AnyView

    init<Content: View>(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        content: @autoclosure @escaping () -> Content
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = {
            AnyView(content().navigationTitle(title))
        }
    }
}

// MARK: - CaseIterable

extension Menu: CaseIterable {
    static var allCases: [Self] = [
        dynamicTableView,
        separators,
        pickers,
        buttonsUIKit,
        buttons,
        textViewController,
        feedViewController,
        alertsViewController,
        carouselUIKit,
        carousel,
        labelInset
    ]
}

// MARK: - Items

extension Menu {
    static let dynamicTableView = Self(
        title: "Dynamic Table View",
        subtitle: "Data-driven table view",
        content: WrapUIViewController<ExampleDynamicTableViewController>()
    )

    static let separators = Self(
        title: "Separators",
        content: WrapUIViewController<SeparatorViewController>()
    )

    static let pickers = Self(
        title: "Pickers",
        content: WrapUIViewController<PickersViewController>()
    )

    static let buttonsUIKit = Self(
        title: "Buttons",
        subtitle: "UIKit",
        content: WrapUIViewController<ButtonsViewController>()
    )

    static let buttons = Self(
        title: "Buttons",
        subtitle: "SwiftUI",
        content: ButtonsView()
    )

    static let textViewController = Self(
        title: "TextViewController",
        content: WrapUIViewController<ExampleTextViewController>()
    )

    static let feedViewController = Self(
        title: "FeedViewController",
        content: WrapUIViewController<FeedViewController>()
    )

    static let alertsViewController = Self(
        title: "AlertsViewController",
        content: WrapUIViewController<AlertsViewController>()
    )

    static let carouselUIKit = Self(
        title: "Carousel",
        subtitle: "UIKit",
        content: WrapUIViewController<CarouselViewController>()
    )

    static let carousel = Self(
        title: "Carousel",
        subtitle: "SwiftUI",
        content: Carousel(items: [
            .init(title: "First Item", image: r(.blueJay)),
            .init(title: "Second Item", image: r(.blueJay)),
            .init(title: "Third Item", image: r(.blueJay))
        ])
    )

    static let labelInset = Self(
        title: "Label Inset",
        subtitle: "Label extension to enable \"contentInset\".",
        content: WrapUIViewController<ExampleLabelInsetViewController>()
    )
}
