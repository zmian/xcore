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
        labelInset
    ]
}

// MARK: - Items

extension Menu {
    static let separators = Self(
        title: "Separators",
        content: SeparatorViewController().embedInView()
    )

    static let buttonsUIKit = Self(
        title: "Buttons",
        subtitle: "UIKit",
        content: ButtonsViewController().embedInView()
    )

    static let buttons = Self(
        title: "Buttons",
        subtitle: "SwiftUI",
        content: ButtonsView()
    )

    static let capsules = Self(
        title: "Capsule",
        subtitle: "SwiftUI",
        content: {
            if #available(iOS 15.0, *) {
                CapsuleViewPreviews()
            } else {
                EmptyView()
            }
        }
    )

    static let labelInset = Self(
        title: "Label Inset",
        subtitle: "Label extension to enable \"contentInset\".",
        content: ExampleLabelInsetViewController().embedInView()
    )
}
