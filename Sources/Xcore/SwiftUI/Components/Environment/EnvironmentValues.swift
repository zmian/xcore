//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Theme

extension EnvironmentValues {
    @Entry public var theme: Theme = .default
}

// MARK: - DefaultButtonFont

extension EnvironmentValues {
    @Entry public var defaultButtonFont: Font?
}

// MARK: - DefaultMinButtonHeight

extension EnvironmentValues {
    @Entry public var defaultMinButtonHeight: CGFloat = 50
}

// MARK: - DefaultOulineButtonBorderColor

extension EnvironmentValues {
    @Entry public var defaultOutlineButtonBorderColor: Color?
}

// MARK: - View Modifiers

extension View {
    public func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }

    public func defaultMinButtonHeight(_ value: CGFloat) -> some View {
        environment(\.defaultMinButtonHeight, value)
    }

    public func defaultButtonFont(_ value: Font?) -> some View {
        environment(\.defaultButtonFont, value)
    }
}
