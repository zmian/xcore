//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@MainActor
struct Menu: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String?
    let content: AnyView

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        content: @autoclosure () -> some View
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content()
            .navigationTitle(title)
            .eraseToAnyView()
    }

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> some View
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content()
            .navigationTitle(title)
            .eraseToAnyView()
    }
}

// MARK: - CaseIterable

extension Menu: @preconcurrency CaseIterable {
    static var allCases: [Self] = [
        separators,
        buttons,
        capsules,
        money,
        labeledContent,
        popups,
        textFields,
        text,
        story,
        images,
        window,
        share,
        hapticFeedback,
        crypt
    ]
}

// MARK: - Items

extension Menu {
    private static let separators = Self(
        title: "Separators",
        content: SeparatorsView()
    )

    private static let buttons = Self(
        title: "Buttons",
        content: ButtonsView()
    )

    private static let capsules = Self(
        title: "Capsule",
        content: Samples.capsuleViewPreviews
    )

    private static let money = Self(
        title: "Money",
        content: MoneyView()
    )

    private static let labeledContent = Self(
        title: "LabeledContent",
        content: LabeledContentView()
    )

    private static let popups = Self(
        title: "Popups",
        content: Samples.popupPreviews
    )

    private static let textFields = Self(
        title: "TextFields",
        content: Samples.dynamicTextFieldPreviews
    )

    private static let text = Self(
        title: "Text",
        subtitle: "Built-in Markdown Support",
        content: TextView()
    )

    private static let story = Self(
        title: "Story",
        content: StoryPreviewView()
    )

    private static let images = Self(
        title: "Images Loader",
        content: ImagesView()
    )

    private static let window = Self(
        title: "Window Overlay",
        content: Samples.OverlayScreenPreview()
    )

    private static let share = Self(
        title: "Share",
        content: ShareView()
    )

    private static let hapticFeedback = Self(
        title: "Haptic Feedback",
        content: HapticFeedbackView()
    )

    private static let crypt = Self(
        title: "Crypt",
        content: CryptView()
    )
}
