//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that takes over all the available space.
///
/// It's useful when you want to set background to take a over all the available
/// space.
public struct FillView<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        Color.clear
            .frame(max: .infinity)
            .overlay(content)
    }
}
