//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

extension WebViewController {
    public struct Style {
        public let id: Identifier<Style>
        public var title: String
        public var loaderClass: ViewMaskable.Type
        public var preferredNavigationBarBackground: Chrome.Style

        public init(id: Identifier<Style>) {
            self.id = id
            self.title = ""
            self.loaderClass = LoadingView.self
            self.preferredNavigationBarBackground = .blurred
        }

        var configureLoader: ((_ loader: ViewMaskable) -> Void)?
        public mutating func configureLoader(_ callback: @escaping (_ loader: ViewMaskable) -> Void) {
            configureLoader = callback
        }

        var configureProgressBar: (_ progressBar: ProgressView) -> Void = { _ in }
        public mutating func configureProgressBar(_ callback: @escaping (_ progressBar: ProgressView) -> Void) {
            configureProgressBar = callback
        }

        var saveFilenameConvention: (_ url: URL) -> String = {
            $0.relativePath.lastPathComponent
        }
        public mutating func saveFilenameConvention(_ callback: @escaping (_ url: URL) -> String) {
            saveFilenameConvention = callback
        }

        var evaluateJavaScript: (_ webView: WKWebView) -> Void = { _ in }
        public mutating func evaluateJavaScript(_ callback: @escaping (_ webView: WKWebView) -> Void) {
            evaluateJavaScript = callback
        }

        /// A convenience function to apply styles using block based api.
        ///
        /// - Parameter configure: The configuration block to apply.
        @discardableResult
        public func apply(_ configure: (inout Style) throws -> Void) rethrows -> Style {
            var object = self
            try configure(&object)
            return object
        }
    }
}

// MARK: - Conformance

extension WebViewController.Style: CustomStringConvertible {
    public var description: String {
        id.rawValue
    }
}

extension WebViewController.Style: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension WebViewController.Style: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Built-in

extension WebViewController.Style {
    public static func setDefault(_ style: @escaping (_ title: String) -> Self) {
        _default = style
    }

    /// The default app style.
    private static var _default: (_ title: String) -> Self = Self.modern
    public static func `default`(title: String) -> Self {
        _default(title)
    }

    public static var `default`: Self {
        `default`(title: "")
    }
}

extension WebViewController.Style {
    /// A modern style with a simple loading bar.
    public static func modern(title: String) -> Self {
        Self.init(id: "xcore.modern").apply {
            $0.title = title
            $0.configureProgressBar { progressBar in
                let color = UIColor.appTint
                progressBar.backgroundColor = color
                progressBar.addBorder(edges: .bottom, color: color, thickness: .onePixel)
                progressBar.fillHeight = 2
            }
        }
    }
}
