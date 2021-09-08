//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Theme

extension EnvironmentValues {
    private struct ThemeKey: EnvironmentKey {
        static var defaultValue: Theme = .default
    }

    public var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - DefaultMinButtonHeight

extension EnvironmentValues {
    private struct DefaultMinButtonHeightKey: EnvironmentKey {
        static var defaultValue: CGFloat = 50
    }

    public var defaultMinButtonHeight: CGFloat {
        get { self[DefaultMinButtonHeightKey.self] }
        set { self[DefaultMinButtonHeightKey.self] = newValue }
    }
}

// MARK: - DefaultOulineButtonBorderColor

extension EnvironmentValues {
    private struct DefaultOutlineButtonBorderColorKey: EnvironmentKey {
        static var defaultValue: Color?
    }

    public var defaultOutlineButtonBorderColor: Color? {
        get { self[DefaultOutlineButtonBorderColorKey.self] }
        set { self[DefaultOutlineButtonBorderColorKey.self] = newValue }
    }
}

// MARK: - DefaultAppTypeface

extension EnvironmentValues {
    private struct DefaultAppTypefaceKey: EnvironmentKey {
        static var defaultValue = UIFont.defaultAppTypeface
    }

    // TODO: Implement the app function to pick the typeface from environment.
    var defaultAppTypeface: UIFont.Typeface {
        get { self[DefaultAppTypefaceKey.self] }
        set { self[DefaultAppTypefaceKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }

    public func defaultMinButtonHeight(_ value: CGFloat) -> some View {
        environment(\.defaultMinButtonHeight, value)
    }
}
