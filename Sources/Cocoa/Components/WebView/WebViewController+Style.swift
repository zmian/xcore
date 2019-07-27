//
// WebViewController+Style.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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

        var saveFileNameConvention: (_ url: URL) -> String = {
            $0.relativePath.lastPathComponent
        }
        public mutating func saveFileNameConvention(_ callback: @escaping (_ url: URL) -> String) {
            saveFileNameConvention = callback
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
        return id.rawValue
    }
}

extension WebViewController.Style: Equatable {
    public static func == (lhs: WebViewController.Style, rhs: WebViewController.Style) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WebViewController.Style: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

// MARK: - Built-in

extension WebViewController.Style {
    public static func setDefault(_ style: @escaping (_ title: String) -> WebViewController.Style) {
        _default = style
    }

    /// The default app style.
    private static var _default: (_ title: String) -> WebViewController.Style = WebViewController.Style.modern
    public static func `default`(title: String) -> WebViewController.Style {
        return _default(title)
    }

    public static var `default`: WebViewController.Style {
        return `default`(title: "")
    }
}

extension WebViewController.Style {
    private static func modern(title: String) -> WebViewController.Style {
        return WebViewController.Style(id: "xcore.modern").apply {
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
