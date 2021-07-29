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
            content()
                .navigationTitle(title)
                .eraseToAnyView()
        }
    }

    init<Content: View>(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = {
            content()
                .navigationTitle(title)
                .eraseToAnyView()
        }
    }
}

// MARK: - CaseIterable

extension Menu: CaseIterable {
    static var allCases: [Self] = [
        separators,
        buttonsUIKit,
        buttons,
        capsules,
        popups,
        textFields,
        activitySheet,
        labelInset
    ]
}

// MARK: - Items

extension Menu {
    private static let separators = Self(
        title: "Separators",
        subtitle: "UIKit",
        content: SeparatorViewController().embedInView()
    )

    private static let buttonsUIKit = Self(
        title: "Buttons",
        subtitle: "UIKit",
        content: ButtonsViewController().embedInView()
    )

    private static let buttons = Self(
        title: "Buttons",
        content: ButtonsView()
    )

    private static let capsules = Self(
        title: "Capsule",
        content: {
            if #available(iOS 15.0, *) {
                Samples.capsuleViewPreviews
            } else {
                EmptyView()
            }
        }
    )

    private static let popups = Self(
        title: "Popups",
        content: {
            if #available(iOS 15.0, *) {
                Samples.popupPreviews
            } else {
                EmptyView()
            }
        }
    )

    private static let textFields = Self(
        title: "TextFields",
        content: {
            if #available(iOS 15.0, *) {
                Samples.dynamicTextFieldPreviews
            } else {
                EmptyView()
            }
        }
    )

    private static let activitySheet = Self(
        title: "Activity Sheet",
        content: ActivitySheetView()
    )

    private static let labelInset = Self(
        title: "Label Inset",
        subtitle: "Label extension to enable \"contentInset\".",
        content: ExampleLabelInsetViewController().embedInView()
    )
}
