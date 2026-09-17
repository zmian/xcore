//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

enum Destination: Hashable, CaseIterable, Identifiable, Sendable {
    case separators
    case buttons
    case capsules
    case money
    case labeledContent
    case popups
    case textFields
    case text
    case dataStatusView
    case dataStatusList
    case story
    case font
    case images
    case window
    case share
    case hapticFeedback
    case crypt
    case scrollingStack

    var id: Self {
        self
    }

    var icon: SystemAssetIdentifier {
        metadata.icon
    }

    var title: String {
        metadata.title
    }

    var subtitle: String? {
        metadata.subtitle
    }

    @MainActor
    var content: some View {
        contentBody
            .navigationTitle(title)
    }
}

// MARK: - Content

extension Destination {
    @MainActor
    @ViewBuilder
    private var contentBody: some View {
        switch self {
            case .separators:
                SeparatorsView()
            case .buttons:
                ButtonsView()
            case .capsules:
                Samples.capsuleViewPreviews
            case .money:
                Samples.moneyPreviews
            case .labeledContent:
                LabeledContentView()
            case .popups:
                Samples.popupPreviews
            case .textFields:
                Samples.dynamicTextFieldPreviews
            case .text:
                TextView()
            case .dataStatusView:
                DataStatusViewPreview()
            case .dataStatusList:
                DataStatusListPreview()
            case .story:
                StoryPreviewView()
            case .font:
                FontView()
            case .images:
                ImagesView()
            case .window:
                Samples.OverlayScreenPreview()
            case .share:
                ShareView()
            case .hapticFeedback:
                HapticFeedbackView()
            case .crypt:
                CryptView()
            case .scrollingStack:
                ScrollingStack(edge: .both)
        }
    }
}

// MARK: - Metadata

extension Destination {
    private var metadata: (icon: SystemAssetIdentifier, title: String, subtitle: String?) {
        switch self {
            case .separators:
                (.minus, "Separators", nil)
            case .buttons:
                ("button.horizontal", "Buttons", nil)
            case .capsules:
                (.capsule, "Capsule", nil)
            case .money:
                (.dollarsignCircle, "Money", nil)
            case .labeledContent:
                ("list.bullet.below.rectangle", "LabeledContent", nil)
            case .popups:
                ("inset.filled.center.rectangle", "Popups", nil)
            case .textFields:
                ("character.cursor.ibeam", "TextFields", nil)
            case .text:
                (.docRichtext, "Text", "Built-in Markdown Support")
            case .dataStatusView:
                ("rectangle.2.swap", "Data Status View", "Custom views for each state of DataStatus")
            case .dataStatusList:
                ("list.bullet.rectangle.portrait", "Data Status List", "List with support for each state of DataStatus")
            case .story:
                ("rectangle.split.2x1", "Story", nil)
            case .font:
                ("textformat", "Variable Fonts", nil)
            case .images:
                ("photo.badge.arrow.down", "Images Loader", nil)
            case .window:
                ("inset.filled.rectangle", "Window Overlay", nil)
            case .share:
                (.squareAndArrowUp, "Share", nil)
            case .hapticFeedback:
                (.waveform, "Haptic Feedback", nil)
            case .crypt:
                (.lockShield, "Crypt", nil)
            case .scrollingStack:
                (.squareStack, "Scrolling Stack", nil)
        }
    }
}
