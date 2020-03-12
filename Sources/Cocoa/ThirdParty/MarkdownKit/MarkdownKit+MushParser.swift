//
// MarkdownKit+MushParser.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

#if canImport(Haring)
import Haring

/// Custom tags to support extra features in Markdown: Text color, background color, and font.
/// MarkdownKit provides support to add custom tags support.
/// https://github.com/ivanbruel/MarkdownKit#extensibility
///
/// The following test string ensures that Markdown parser is implemented correctly with our custom tags.
///
/// **Markdown Acid Test**
/// ```
/// Community Rules {font:HelveticaNeue,24pt|text in {#bada55|green} a different font}\n\n {#bada55|the {bg#FFD700|should have gold color} text} {bg#bada55|the {#FFD700|should have gold color} text} **3 Bold** {bg#bada55|the text} \n\n**{#FFD700|adsdndsajhdajksdred text}** _{#ff0000|red text}_ __{#bada55|green text}__\n\n##Rule 1: Reddit's site-wide rules\n\n\n**[Tap Here](http://www.reddit.com/rules) for reddit's 6 rules.**  \n\nThey are all pretty straight forward
/// ```
/// <img src="https://user-images.githubusercontent.com/621693/57246709-f2aebd80-700b-11e9-91f8-4cb1e87c293a.png" height="70" width="120"/>
final class MarkdownTextColor: MarkdownElement {
    var regex: String {
        "(\\{#)(.+?)(\\|)((.|\n|\r)+?)(\\})"
    }

    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        let colorHexCode = attributedString.attributedSubstring(from: match.range(at: 2)).string
        let textRange = match.range(at: 4)
        let attributesFromString = attributedString.attributedSubstring(from: textRange)
        let formattedString = NSMutableAttributedString(attributedString: attributesFromString)
        formattedString.addAttribute(.foregroundColor, value: UIColor(hex: colorHexCode), range: NSRange(location: 0, length: textRange.length))
        attributedString.replaceCharacters(in: match.range, with: formattedString)
    }
}

final class MarkdownBackgroundColor: MarkdownElement {
    var regex: String {
        "(\\{bg#)(.+?)(\\|)((.|\n|\r)+?)(\\})"
    }

    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        let colorHexCode = attributedString.attributedSubstring(from: match.range(at: 2)).string
        let textRange = match.range(at: 4)
        let attributesFromString = attributedString.attributedSubstring(from: textRange)
        let formattedString = NSMutableAttributedString(attributedString: attributesFromString)
        formattedString.addAttribute(.backgroundColor, value: UIColor(hex: colorHexCode), range: NSRange(location: 0, length: textRange.length))
        attributedString.replaceCharacters(in: match.range, with: formattedString)
    }
}

final class MarkdownCustomFont: MarkdownElement {
    var regex: String {
        "(\\{font:)(.+?)(\\|)((.|\n|\r)+?)(\\})"
    }

    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        let fontComponents = attributedString.attributedSubstring(from: match.range(at: 2)).string.components(separatedBy: ",")
        guard
            let fontName = fontComponents.first,
            let fontSizeString = fontComponents.last,
            let fontSize = Double(String(fontSizeString.dropLast(2))),
            let font = UIFont(name: fontName, size: CGFloat(fontSize))
        else {
            return
        }

        let textRange = match.range(at: 4)
        let attributesFromString = attributedString.attributedSubstring(from: textRange)
        let formattedString = NSMutableAttributedString(attributedString: attributesFromString)
        formattedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: textRange.length))
        attributedString.replaceCharacters(in: match.range, with: formattedString)
    }
}

final class MarkdownUnderline: MarkdownElement {
    var regex: String {
        "(=_)((.|\n|\r)+?)(=_)"
    }

    func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: regex, options: [])
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        let textRange = match.range(at: 2)
        let attributesFromString = attributedString.attributedSubstring(from: textRange)
        let formattedString = NSMutableAttributedString(attributedString: attributesFromString)
        formattedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textRange.length))
        attributedString.replaceCharacters(in: match.range, with: formattedString)
    }
}
#endif
