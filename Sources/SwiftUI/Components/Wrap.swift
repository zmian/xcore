//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - UIViewControllerRepresentable

public struct WrapUIViewController<Content: UIViewController>: UIViewControllerRepresentable {
    public init() { }

    public func makeUIViewController(context: Context) -> Content {
        Content()
    }

    public func updateUIViewController(_ uiViewController: Content, context: Context) {}
}

// MARK: - UIViewRepresentable

public struct WrapUIView<Content: UIView>: UIViewRepresentable {
    public init() { }

    public func makeUIView(context: Context) -> Content {
        Content()
    }

    public func updateUIView(_ uiView: Content, context: Context) {}
}
