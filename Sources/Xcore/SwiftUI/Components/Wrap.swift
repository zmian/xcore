//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - UIViewController Wrapper

extension UIViewController {
    /// Embed this view controller in `SwiftUI.View`.
    public func embedInView() -> some View {
        Wrapper { self }
    }

    private struct Wrapper<Content: UIViewController>: UIViewControllerRepresentable {
        private let content: () -> Content

        public init(_ content: @escaping () -> Content) {
            self.content = content
        }

        public func makeUIViewController(context: Context) -> Content {
            content()
        }

        public func updateUIViewController(_ uiViewController: Content, context: Context) {}
    }
}

// MARK: - UIView Wrapper

extension UIView {
    /// Embed this view in `SwiftUI.View`.
    public func embedInView() -> some View {
        Wrapper { self }
    }

    private struct Wrapper<Content: UIView>: UIViewRepresentable {
        private let content: () -> Content

        public init(_ content: @escaping () -> Content) {
            self.content = content
        }

        public func makeUIView(context: Context) -> Content {
            content()
        }

        public func updateUIView(_ uiView: Content, context: Context) {}
    }
}
