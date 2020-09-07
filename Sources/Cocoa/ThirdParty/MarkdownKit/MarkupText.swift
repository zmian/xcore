//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

#if canImport(Haring)
import Haring

// MARK: - MarkupText

public struct MarkupText: CustomStringConvertible {
    private var markupText: MarkupTextBuilder

    /// The unformatted representation of the markup text.
    public let rawValue: String

    public init(_ text: String) {
        rawValue = text
        markupText = .text(text)
    }

    private func apply(build: (MarkupTextBuilder) -> MarkupTextBuilder) -> Self {
        var copy = Self(rawValue)
        copy.markupText = build(markupText)
        return copy
    }

    public func font(_ font: UIFont) -> Self {
        apply { $0.font(font) }
    }

    public func color(_ color: UIColor) -> Self {
        apply { $0.color(color) }
    }

    public func underline() -> Self {
        apply { $0.underline() }
    }

    public func bold() -> Self {
        apply { $0.bold() }
    }

    public var description: String {
        markupText.description
    }
}

// MARK: - MarkupTextBuilder

private indirect enum MarkupTextBuilder: CustomStringConvertible {
    case text(String)
    case textColor(color: String, block: Self)
    case font(font: UIFont, block: Self)
    case underline(block: Self)
    case bold(block: Self)

    func font(_ font: UIFont) -> Self {
        .font(font: font, block: self)
    }

    func color(_ color: UIColor) -> Self {
        .textColor(color: color.hex, block: self)
    }

    func underline() -> Self {
        .underline(block: self)
    }

    func bold() -> Self {
        .bold(block: self)
    }

    var description: String {
        Self.build(self)
    }
}

extension MarkupTextBuilder {
    private static func build(_ block: Self) -> String {
        switch block {
            case .text(let text):
                return text
            case .textColor(let color, let tail):
                return "{\(color)|\(build(tail))}"
            case .font(let font, let tail):
                return "{font:\(font.fontName),\(font.pointSize)pt|\(build(tail))}"
            case .underline(let tail):
                return "=_\(build(tail))=_"
            case .bold(let tail):
                return "**\(build(tail))**"
        }
    }
}

// MARK: - MarkupText: Local Link

extension MarkupText {
    /// Creates a local link with custom scheme. This ensures that the link plays
    /// nicely with accessibility.
    ///
    /// This is useful to create links in attributed string that has local action
    /// handler.
    public static func localLink(text: String) -> String {
        let linkText = text.urlEscaped() ?? text
        let linkUrl = "\(URL.Scheme.localLink)://\(linkText)"
        return "[\(text)](\(linkUrl))"
    }
}

// MARK: - Scheme

extension URL.Scheme {
    public static let localLink: URL.Scheme = "locallink"
}

#endif
