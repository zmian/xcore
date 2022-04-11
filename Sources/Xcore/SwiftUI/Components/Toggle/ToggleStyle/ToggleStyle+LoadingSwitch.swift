//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct LoadingSwitchToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.isLoading) { isLoading in
            HStack {
                configuration.label

                Spacer()

                if isLoading {
                    ProgressView()
                    // 50 points is the width of Switch control.
                    // Width is set to 50 to avoid content shifting when changing state between
                    // loading.
                    .frame(width: 50, alignment: .trailing)
                } else {
                    Toggle(isOn: configuration.$isOn) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
            }
            .animation(.default, value: isLoading)
        }
    }
}

// MARK: - Dot Syntax Support

extension ToggleStyle where Self == LoadingSwitchToggleStyle {
    public static var loadingSwitch: Self { .init() }
}
