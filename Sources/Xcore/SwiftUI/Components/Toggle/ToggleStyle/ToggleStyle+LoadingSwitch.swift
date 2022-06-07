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
                    // 51 x 31 points is the size of Switch control.
                    // Ideal size is set to match switch to avoid content shifting when changing
                    // state between loading.
                    .frame(idealWidth: 51, idealHeight: 31, alignment: .trailing)
                    .fixedSize()
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
