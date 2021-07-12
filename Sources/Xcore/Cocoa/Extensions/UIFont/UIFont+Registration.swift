//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    public enum RegistrationError: Error {
        case fontNotFound
        case remoteFontUrlDetected
        case failedToCreateFont
        case failedToRegisterFont
        case failedToUnregisterFont
    }

    /// Registers the fonts if they are not already registered with the font
    /// manager.
    ///
    /// - Parameters:
    ///   - fontNames: The list of font names to register.
    ///   - bundle: The bundle where font is located.
    public static func registerIfNeeded(_ fontNames: String..., bundle: Bundle = .main) throws {
        try fontNames.forEach {
            let name = $0.deletingPathExtension
            let ext = $0.pathExtension

            guard let url = bundle.url(forResource: name, withExtension: ext) else {
                throw RegistrationError.fontNotFound
            }

            try UIFont.registerIfNeeded($0, url: url)
        }
    }

    /// Registers the font if it's not already registered with the font manager.
    ///
    /// - Parameters:
    ///   - fontName: The PostScript name of the font used to check whether the font
    ///     can be registered.
    ///   - fontUrl: The local url where the font is located.
    public static func registerIfNeeded(_ fontName: String, url fontUrl: URL) throws {
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
    ///   - fontName: The PostScript name of the font used to check whether the font
    ///     can be unregistered.
    ///   - fontUrl: The local url where the font is located.
    public static func unregisterIfExists(_ fontName: String, url fontUrl: URL) throws {
        let name = fontName.deletingPathExtension

        // Check if the given font is registered with font manager before attempting to
        // unregister.
        guard !fontNames(forFamilyName: name).isEmpty else {
            return
        }

        try unregister(url: fontUrl)
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
    public static func register(
        url fontUrl: URL,
        unregisterOldFirstIfExists: Bool = false
    ) throws -> String {
        let (fontName, cgFont) = try metadata(from: fontUrl)

        // Check if the given font is already registered with font manager.
        let exists = !fontNames(forFamilyName: fontName).isEmpty

        if exists {
            if unregisterOldFirstIfExists {
                try unregister(fontName, cgFont: cgFont)
            } else {
                #if DEBUG
                Console.info("\"\(fontName)\" font already registered.")
                #endif
                return fontName
            }
        }

        var fontError: Unmanaged<CFError>?

        guard CTFontManagerRegisterGraphicsFont(cgFont, &fontError) else {
            if let fontError = fontError?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(fontError)
                #if DEBUG
                Console.error("Failed to register font \"\(fontName)\" with font manager: \(String(describing: errorDescription))")
                #endif
            }

            throw RegistrationError.failedToRegisterFont
        }

        #if DEBUG
        Console.info("Successfully registered font \"\(fontName)\".")
        #endif
        return fontName
    }

    /// Unregisters the font at given url with the font manager.
    ///
    /// - Parameter fontUrl: The font url to be unregistered.
    private static func unregister(url fontUrl: URL) throws {
        let (fontName, cgFont) = try metadata(from: fontUrl)
        try unregister(fontName, cgFont: cgFont)
    }

    /// Unregisters the specified font with the font manager.
    ///
    /// - Parameter fontUrl: The font to be unregistered.
    private static func unregister(_ fontName: String, cgFont: CGFont) throws {
        // Check if the given font is registered with font manager before attempting to
        // unregister.
        guard !fontNames(forFamilyName: fontName).isEmpty else {
            #if DEBUG
            Console.info("\"\(fontName)\" font isn't registered.")
            #endif
            return
        }

        var fontError: Unmanaged<CFError>?
        CTFontManagerUnregisterGraphicsFont(cgFont, &fontError)

        if let fontError = fontError?.takeRetainedValue() {
            let errorDescription = CFErrorCopyDescription(fontError)
            #if DEBUG
            Console.error("Failed to unregister font \"\(fontName)\" with font manager: \(String(describing: errorDescription))")
            #endif
            throw RegistrationError.failedToUnregisterFont
        }

        #if DEBUG
        Console.info("Successfully unregistered font \"\(fontName)\".")
        #endif
    }

    /// Returns PostScript name of font and `CGFont` object from the given url.
    ///
    /// - Parameter fontUrl: The font url to extract the metadata for.
    /// - Returns: Returns a tuple containing PostScript name of the font and
    ///   `CGFont`.
    private static func metadata(from fontUrl: URL) throws -> (postScriptName: String, cgFont: CGFont) {
        guard fontUrl.schemeType == .file else {
            throw RegistrationError.remoteFontUrlDetected
        }

        guard
            let dataProvider = CGDataProvider(url: fontUrl as CFURL),
            let cgFont = CGFont(dataProvider),
            let postScriptName = cgFont.postScriptName
        else {
            throw RegistrationError.failedToCreateFont
        }

        let fontName = String(describing: postScriptName)
        return (fontName, cgFont)
    }
}
