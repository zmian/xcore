//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@MainActor
struct Destination: Identifiable {
    let id: UUID
    let icon: SystemAssetIdentifier
    let title: String
    let subtitle: String?
    let content: AnyView

    init(
        id: UUID = UUID(),
        icon: SystemAssetIdentifier,
        title: String,
        subtitle: String? = nil,
        content: @autoclosure () -> some View
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
            .navigationTitle(title)
            .eraseToAnyView()
    }

    init(
        id: UUID = UUID(),
        icon: SystemAssetIdentifier,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> some View
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
            .navigationTitle(title)
            .eraseToAnyView()
    }
}

// MARK: - CaseIterable

extension Destination: @preconcurrency CaseIterable {
    static let allCases: [Self] = [
        separators,
        buttons,
        capsules,
        money,
        labeledContent,
        popups,
        textFields,
        text,
        dataStatusView,
        dataStatusList,
        story,
        images,
        window,
        share,
        hapticFeedback,
        crypt
    ]
}

// MARK: - Items

extension Destination {
    private static let separators = Self(
        icon: .minus,
        title: "Separators",
        content: SeparatorsView()
    )

    private static let buttons = Self(
        icon: "button.horizontal",
        title: "Buttons",
        content: ButtonsView()
    )

    private static let capsules = Self(
        icon: .capsule,
        title: "Capsule",
        content: Samples.capsuleViewPreviews
    )

    private static let money = Self(
        icon: .dollarsignCircle,
        title: "Money",
        content: Samples.moneyPreviews
    )

    private static let labeledContent = Self(
        icon: "list.bullet.below.rectangle",
        title: "LabeledContent",
        content: LabeledContentView()
    )

    private static let popups = Self(
        icon: "inset.filled.center.rectangle",
        title: "Popups",
        content: Samples.popupPreviews
    )

    private static let textFields = Self(
        icon: "character.cursor.ibeam",
        title: "TextFields",
        content: Samples.dynamicTextFieldPreviews
    )

    private static let text = Self(
        icon: .docRichtext,
        title: "Text",
        subtitle: "Built-in Markdown Support",
        content: TextView()
    )

    private static let dataStatusView = Self(
        icon: "rectangle.2.swap",
        title: "Data Status View",
        subtitle: "Custom views for each state of DataStatus",
        content: DataStatusViewPreview()
    )

    private static let dataStatusList = Self(
        icon: "list.bullet.rectangle.portrait",
        title: "Data Status List",
        subtitle: "List with support for each state of DataStatus",
        content: DataStatusListPreview()
    )

    private static let story = Self(
        icon: "rectangle.split.2x1",
        title: "Story",
        content: StoryPreviewView()
    )

    private static let images = Self(
        icon: "photo.badge.arrow.down",
        title: "Images Loader",
        content: ImagesView()
    )

    private static let window = Self(
        icon: "inset.filled.rectangle",
        title: "Window Overlay",
        content: Samples.OverlayScreenPreview()
    )

    private static let share = Self(
        icon: .squareAndArrowUp,
        title: "Share",
        content: ShareView()
    )

    private static let hapticFeedback = Self(
        icon: .waveform,
        title: "Haptic Feedback",
        content: HapticFeedbackView()
    )

    private static let crypt = Self(
        icon: .lockShield,
        title: "Crypt",
        content: CryptView()
    )
}
