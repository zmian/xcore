//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@MainActor
extension Toggle {
    /// Creates a toggle that generates its label from a title and subtitle strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - subtitle: A string that provides further information about the toggle.
    ///   - isOn: A binding to a property that determines whether the toggle is on or off.
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        isOn: Binding<Bool>,
        spacing: CGFloat? = nil
    ) where Label == _XIVTSSV {
        self.init(isOn: isOn) {
            _XIVTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        }
    }

    /// Creates a toggle that generates its label from a title text and subtitle
    /// string.
    ///
    /// - Parameters:
    ///   - title: A text that describes the purpose of the toggle.
    ///   - subtitle: A string that provides further information about the toggle.
    ///   - isOn: A binding to a property that determines whether the toggle is on or off.
    public init(
        _ title: Text,
        subtitle: Text?,
        isOn: Binding<Bool>,
        spacing: CGFloat? = nil
    ) where Label == _XIVTSSV {
        self.init(isOn: isOn) {
            _XIVTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isOn = false
    let label = isOn ? "Connected" : "Disconnected"
    let icon = Text("\(Image(system: .circleFill))")
        .foregroundStyle(isOn ? .green : .red)

    List {
        Toggle("WiFi", subtitle: "Home Network", isOn: $isOn)

        Toggle(Text("WiFi"), subtitle: Text("\(icon) \(label)"), isOn: $isOn)

        Toggle(isOn: $isOn) {
            Text("WiFi")
            Text("\(icon) \(label)")
        }
    }
}
