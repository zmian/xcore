//
// UIFont+Loader.swift
//
// Copyright © 2018 Zeeshan Mian
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

extension UIFont {
    public enum LoaderError: Error {
        case fontNotFound
        case remoteFontUrlDetected
        case failedToCreateFont
        case failedToRegisterFont
    }

    /// Loads the font if it's not already registered with the system.
    ///
    /// - Parameters:
    ///   - fontName: The font name to load.
    ///   - fontUrl: The local url where the font is located.
    public static func loadIfNeeded(fontName: String, url fontUrl: URL) throws {
        let name = fontName.stringByDeletingPathExtension

        /// Loads the given font into memory.
        guard UIFont.fontNames(forFamilyName: name).isEmpty else {
            return
        }

        _ = try load(url: fontUrl)
    }

    /// Loads the font at given url into memory.
    ///
    /// - Parameter fontUrl: The font url.
    /// - Returns: Returns the post script name of the font.
    public static func load(url fontUrl: URL) throws -> String {
        guard fontUrl.schemeType == .file else {
            throw LoaderError.remoteFontUrlDetected
        }

        guard
            let fontData = NSData(contentsOf: fontUrl),
            let dataProvider = CGDataProvider(data: fontData),
            let cgFont = CGFont(dataProvider),
            let postScriptName = cgFont.postScriptName
        else {
            throw LoaderError.failedToCreateFont
        }

        let fontName = String(describing: postScriptName)
        var fontError: Unmanaged<CFError>?

        guard CTFontManagerRegisterGraphicsFont(cgFont, &fontError) else {
            if let fontError = fontError?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(fontError)
                Console.error("Failed to load font \"\(fontName)\": \(String(describing: errorDescription))")
            }

            throw LoaderError.failedToRegisterFont
        }

        Console.log("Successfully loaded font \"\(fontName)\".")
        return fontName
    }
}
