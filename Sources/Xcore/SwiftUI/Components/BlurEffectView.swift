//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(iOS, deprecated: 15, message: "Use iOS 15 native `Material` directly.")
public struct BlurEffectView: UIViewRepresentable {
    private let style: UIBlurEffect.Style

    public init(style: UIBlurEffect.Style = .regular) {
        self.style = style
    }

    public func makeUIView(context: Context) -> BlurView {
        BlurView(style: style)
    }

    public func updateUIView(_ uiView: BlurView, context: Context) {}
}
