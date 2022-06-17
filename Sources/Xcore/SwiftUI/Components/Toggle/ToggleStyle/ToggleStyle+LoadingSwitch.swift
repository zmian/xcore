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

                ZStack(alignment: .trailing) {
                    ProgressView()
                        .hidden(!isLoading)

                    Toggle(isOn: configuration.$isOn) {
                        EmptyView()
                    }
                    .labelsHidden()
                    .hidden(isLoading)
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
