//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - DefaultMinButtonHeight

private struct DefaultMinButtonHeightKey: EnvironmentKey {
    static var defaultValue: CGFloat = 50
}

extension EnvironmentValues {
    public var defaultMinButtonHeight: CGFloat {
        get { self[DefaultMinButtonHeightKey.self] }
        set { self[DefaultMinButtonHeightKey.self] = newValue }
    }
}

// MARK: - DefaultButtonCornerRadius

private struct DefaultButtonCornerRadiusKey: EnvironmentKey {
    static var defaultValue: CGFloat = 8
}

extension EnvironmentValues {
    public var defaultButtonCornerRadius: CGFloat {
        get { self[DefaultButtonCornerRadiusKey.self] }
        set { self[DefaultButtonCornerRadiusKey.self] = newValue }
    }
}

// MARK: - DefaultAppTypeface

private struct DefaultAppTypefaceKey: EnvironmentKey {
    static var defaultValue = UIFont.defaultAppTypeface
}

extension EnvironmentValues {
    // TODO: Implement the app function to pick the typeface from environment.
    var defaultAppTypeface: UIFont.Typeface {
        get { self[DefaultAppTypefaceKey.self] }
        set { self[DefaultAppTypefaceKey.self] = newValue }
    }
}

// MARK: - Theme

private struct ThemeKey: EnvironmentKey {
    static var defaultValue: Theme = .current
}

extension EnvironmentValues {
    public var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
