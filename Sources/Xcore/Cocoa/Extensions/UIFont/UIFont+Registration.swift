//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import Synchronization
import UIKit

extension UIFont {
    private static let mutex = Mutex(())

    private enum RegistrationError: Error, Hashable, LocalizedError {
        case fontNotFound(String)
        case invalidFontURL(URL)
        case invalidFontFile(URL)
        case registrationFailed(URL)
        case unregistrationFailed(URL)

        var errorDescription: String? {
            switch self {
                case let .fontNotFound(name):
                    return "Font resource \"\(name)\" was not found."
                case let .invalidFontURL(url):
                    return "Font URL must reference a local file: \(url.path(percentEncoded: false))."
                case let .invalidFontFile(url):
                    return "No valid font faces were found at \(url.path(percentEncoded: false))."
                case let .registrationFailed(url):
                    return "Failed to register font at \(url.path(percentEncoded: false))."
                case let .unregistrationFailed(url):
                    return "Failed to unregister font at \(url.path(percentEncoded: false))."
            }
        }
    }

    /// Registers the fonts if they are not already registered with the font manager.
    ///
    /// - Parameters:
    ///   - fontNames: The list of font resource names to register.
    ///   - bundle: The bundle where the given list of fonts are located.
    public static func registerIfNeeded(_ fontNames: String..., in bundle: Bundle = .main) throws {
        try fontNames.forEach { fontName in
            let name = fontName.deletingPathExtension
            let ext = fontName.pathExtension

            guard let url = bundle.url(forResource: name, withExtension: ext) else {
                throw RegistrationError.fontNotFound(fontName)
            }

            try registerIfNeeded(at: url)
        }
    }

    /// Registers the font at the given URL if it is not already registered.
    ///
    /// - Parameter fontURL: The local file URL where the font is located.
    public static func registerIfNeeded(at fontURL: URL) throws {
        try mutex.withLock { _ in
            let postScriptNames = try postScriptNames(at: fontURL)

            guard !postScriptNames.allSatisfy(isRegistered) else {
                return
            }

            try registerUnlocked(
                url: fontURL,
                postScriptNames: postScriptNames,
                unregisterOldFirstIfExists: false
            )
        }
    }

    /// Registers the font at the given URL with the font manager.
    ///
    /// - Parameters:
    ///   - fontURL: The local file URL where the font is located.
    ///   - unregisterOldFirstIfExists: If `true`, removes an existing registration
    ///     before registering again.
    /// - Returns: The primary PostScript name discovered in the font file.
    @discardableResult
    public static func register(
        url fontURL: URL,
        unregisterOldFirstIfExists: Bool = false
    ) throws -> String {
        try mutex.withLock { _ in
            let postScriptNames = try postScriptNames(at: fontURL)

            try registerUnlocked(
                url: fontURL,
                postScriptNames: postScriptNames,
                unregisterOldFirstIfExists: unregisterOldFirstIfExists
            )

            return postScriptNames[0]
        }
    }

    /// Unregisters the font if it is registered with the font manager.
    ///
    /// - Parameter fontURL: The local file URL where the font is located.
    public static func unregisterIfExists(at fontURL: URL) throws {
        try mutex.withLock { _ in
            let postScriptNames = try postScriptNames(at: fontURL)

            guard postScriptNames.contains(where: isRegistered) else {
                return
            }

            try unregisterUnlocked(
                url: fontURL,
                postScriptNames: postScriptNames
            )
        }
    }
}

extension UIFont {
    private static func postScriptNames(at fontURL: URL) throws -> [String] {
        guard fontURL.isFileURL else {
            throw RegistrationError.invalidFontURL(fontURL)
        }

        guard
            let descriptors = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as? [CTFontDescriptor],
            !descriptors.isEmpty
        else {
            throw RegistrationError.invalidFontFile(fontURL)
        }

        let names = descriptors
            .compactMap { CTFontDescriptorCopyAttribute($0, kCTFontNameAttribute) as? String }
            .uniqued()

        guard !names.isEmpty else {
            throw RegistrationError.invalidFontFile(fontURL)
        }

        return names
    }

    private static func registerUnlocked(
        url fontURL: URL,
        postScriptNames: [String],
        unregisterOldFirstIfExists: Bool
    ) throws {
        let alreadyRegistered = postScriptNames.contains(where: isRegistered)

        if alreadyRegistered {
            guard unregisterOldFirstIfExists else {
                return
            }

            try unregisterUnlocked(
                url: fontURL,
                postScriptNames: postScriptNames
            )
        }

        var fontError: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(
            fontURL as CFURL,
            .process,
            &fontError
        )

        guard !success else {
            return
        }

        if ctErrorCode(fontError?.takeRetainedValue()) == .alreadyRegistered, postScriptNames.allSatisfy(isRegistered) {
            return
        }

        throw RegistrationError.registrationFailed(fontURL)
    }

    private static func unregisterUnlocked(
        url fontURL: URL,
        postScriptNames: [String]
    ) throws {
        var fontError: Unmanaged<CFError>?
        let success = CTFontManagerUnregisterFontsForURL(
            fontURL as CFURL,
            .process,
            &fontError
        )

        guard !success else {
            return
        }

        if ctErrorCode(fontError?.takeRetainedValue()) == .notRegistered, postScriptNames.allSatisfy({ !isRegistered($0) }) {
            return
        }

        throw RegistrationError.unregistrationFailed(fontURL)
    }

    private static func isRegistered(_ postScriptName: String) -> Bool {
        UIFont(name: postScriptName, size: 1) != nil
    }

    private static func ctErrorCode(_ error: CFError?) -> CTFontManagerError? {
        guard
            let error,
            let domain = CFErrorGetDomain(error) as String?,
            domain == kCTFontManagerErrorDomain as String
        else {
            return nil
        }

        return .init(rawValue: CFErrorGetCode(error))
    }
}
#endif
