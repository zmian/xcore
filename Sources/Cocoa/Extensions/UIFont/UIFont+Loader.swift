//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    enum LoaderError: Error {
        case fontNotFound
        case remoteFontUrlDetected
        case failedToCreateFont
        case failedToRegisterFont
        case failedToUnregisterFont
    }

    /// Registers the font if it's not already registered with the font manager.
    ///
    /// - Parameters:
    ///   - fontName: The font name to register.
    ///   - fontUrl: The local url where the font is located.
    static func registerIfNeeded(fontName: String, url fontUrl: URL) throws {
        let name = fontName.deletingPathExtension

        // Check if the given font is not already registered with font manager before
        // attempting to register.
        guard fontNames(forFamilyName: name).isEmpty else {
            return
        }

        _ = try register(url: fontUrl, unregisterOldFirstIfExists: false)
    }

    /// Unregister the font if it's registered with the font manager.
    ///
    /// - Parameters:
    ///   - fontName: The font name to unregister.
    ///   - fontUrl: The local url where the font is located.
    static func unregisterIfExists(fontName: String, url fontUrl: URL) throws {
        let name = fontName.deletingPathExtension

        // Check if the given font is registered with font manager before
        // attempting to unregister.
        guard !fontNames(forFamilyName: name).isEmpty else {
            return
        }

        _ = try unregister(url: fontUrl)
    }

    /// Registers the font at given url with the font manager.
    ///
    /// - Parameters:
    ///   - fontUrl: The font url to be registered.
    ///   - unregisterOldFirstIfExists: An option to unregister old font first if it
    ///     exists. This is useful if the same font is updated, then unregistering
    ///     the font from font manager first, then registering the new font again.
    ///     The default value is `false`.
    /// - Returns: Returns the post script name of the font.
    static func register(
        url fontUrl: URL,
        unregisterOldFirstIfExists: Bool = false
    ) throws -> String {
        let (cgFont, fontName) = try metadata(from: fontUrl)

        // Check if the given font is already registered with font manager.
        let exists = !fontNames(forFamilyName: fontName).isEmpty

        if exists {
            if unregisterOldFirstIfExists {
                try unregister(cgFont: cgFont, fontName: fontName)
            } else {
                Console.info("Font \"\(fontName)\" already registered.")
                return fontName
            }
        }

        var fontError: Unmanaged<CFError>?

        guard CTFontManagerRegisterGraphicsFont(cgFont, &fontError) else {
            if let fontError = fontError?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(fontError)
                Console.error("Failed to register font \"\(fontName)\" with font manager: \(String(describing: errorDescription))")
            }

            throw LoaderError.failedToRegisterFont
        }

        Console.info("Successfully registered font \"\(fontName)\".")
        return fontName
    }

    /// Unregisters the font at given url with the font manager.
    ///
    /// - Parameter fontUrl: The font url to be unregistered.
    static func unregister(url fontUrl: URL) throws {
        let (cgFont, fontName) = try metadata(from: fontUrl)
        try unregister(cgFont: cgFont, fontName: fontName)
    }

    /// Unregisters the specified font with the font manager.
    ///
    /// - Parameter fontUrl: The font to be unregistered.
    private static func unregister(cgFont: CGFont, fontName: String) throws {
        // Check if the given font is registered with font manager before
        // attempting to unregister.
        guard !fontNames(forFamilyName: fontName).isEmpty else {
            Console.info("Font \"\(fontName)\" isn't registered.")
            return
        }

        var fontError: Unmanaged<CFError>?

        CTFontManagerUnregisterGraphicsFont(cgFont, &fontError)

        if let fontError = fontError?.takeRetainedValue() {
            let errorDescription = CFErrorCopyDescription(fontError)
            Console.error("Failed to unregister font \"\(fontName)\" with font manager: \(String(describing: errorDescription))")
            throw LoaderError.failedToUnregisterFont
        }

        Console.info("Successfully unregistered font \"\(fontName)\".")
    }

    private static func metadata(from fontUrl: URL) throws -> (cgFont: CGFont, postScriptName: String) {
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
        return (cgFont, fontName)
    }
}
