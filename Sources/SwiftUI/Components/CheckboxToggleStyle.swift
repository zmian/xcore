//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension CheckboxToggleStyle {
    public enum Placement {
        case left
        case right
    }
}

public struct CheckboxToggleStyle: ToggleStyle {
    private var placement: Placement

    public init(placement: Placement = .right) {
        self.placement = placement
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            if placement == .right {
                configuration.label
                Spacer()
                toggle(configuration)
            } else {
                toggle(configuration)
                Spacer()
                    .frame(width: .defaultPadding)
                configuration.label
                Spacer()
            }
        }
    }

    private func toggle(_ configuration: Self.Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(24)
            .foregroundColor(
                configuration.isOn ? .accentColor : Color(.appSeparator)
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
