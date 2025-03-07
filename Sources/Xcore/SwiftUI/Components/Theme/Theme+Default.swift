//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Default

extension Theme {
    /// The default theme for the interface.
    nonisolated(unsafe) public static var `default`: Theme = .system
}

// MARK: - System

extension Theme {
    /// The system theme using [UI Element Colors] for the interface.
    ///
    /// [UI Element Colors]: https://developer.apple.com/documentation/uikit/uicolor/ui_element_colors
    private static let system = Theme(
        id: "system",
        tintColor: .accentColor,
        separatorColor: Color(uiColor: .separator),
        borderColor: Color(uiColor: .separator),
        toggleColor: .accentColor,
        linkColor: Color(uiColor: .link),
        placeholderTextColor: Color(uiColor: .placeholderText),

        // Sentiment
        positiveSentimentColor: .green,
        neutralSentimentColor: .gray,
        negativeSentimentColor: .red,

        // Text
        textColor: .primary,
        textSecondaryColor: .secondary,
        textTertiaryColor: Color(uiColor: .tertiaryLabel),
        textQuaternaryColor: Color(uiColor: .quaternaryLabel),

        // Background
        backgroundColor: Color(uiColor: .systemBackground),
        backgroundSecondaryColor: Color(uiColor: .secondarySystemBackground),
        backgroundTertiaryColor: Color(uiColor: .tertiarySystemBackground),

        // Grouped Background
        groupedBackgroundColor: Color(uiColor: .systemGroupedBackground),
        groupedBackgroundSecondaryColor: Color(uiColor: .secondarySystemGroupedBackground),
        groupedBackgroundTertiaryColor: Color(uiColor: .tertiarySystemGroupedBackground),

        // Button Text
        buttonTextColor: { style, state, position in
            switch (style, state, position) {
                case (.outline, .normal, _),
                     (.outline, .pressed, _):
                    return .primary
                case (_, .normal, _):
                    return .white
                case (_, .pressed, _):
                    return .white
                case (_, .disabled, _):
                    return Color(uiColor: .systemGray4)
            }
        },

        // Button Background
        buttonBackgroundColor: { style, state, position in
            switch (style, state, position) {
                case (_, .normal, _):
                    return .accentColor
                case (_, .pressed, _):
                    return .accentColor
                case (_, .disabled, _):
                    return Color(uiColor: .secondarySystemBackground)
            }
        },

        // Toolbar
        toolbarColorScheme: nil
    )
}
