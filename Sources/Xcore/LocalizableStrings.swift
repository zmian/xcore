// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localized {

  internal enum Error {
    /// From your device settings, enable camera access.
    internal static let cameraPermissionDeniedMessage = Localized.tr("Localizable", "error.camera_permission_denied_message")
    /// Camera Permission Denied
    internal static let cameraPermissionDeniedTitle = Localized.tr("Localizable", "error.camera_permission_denied_title")
    /// Seems there is an issue with your device camera.
    internal static let cameraUnavailableMessage = Localized.tr("Localizable", "error.camera_unavailable_message")
    /// Camera Unavailable
    internal static let cameraUnavailableTitle = Localized.tr("Localizable", "error.camera_unavailable_title")
    /// We’ll get this fixed as soon as we can. Please contact support for more information.
    internal static let databaseErrorMessage = Localized.tr("Localizable", "error.database_error_message")
    /// We can’t process this at the moment. Please try again later.
    internal static let generalErrorMessage = Localized.tr("Localizable", "error.general_error_message")
    /// Something Went Wrong
    internal static let generalErrorTitle = Localized.tr("Localizable", "error.general_error_title")
    /// Please complete all information before continuing.
    internal static let generalMissingFieldsMessage = Localized.tr("Localizable", "error.general_missing_fields_message")
    /// Missing Information
    internal static let generalMissingFieldsTitle = Localized.tr("Localizable", "error.general_missing_fields_title")
    /// Please check your internet connection and try again.
    internal static let noInternetMessage = Localized.tr("Localizable", "error.no_internet_message")
    /// No Internet Connection
    internal static let noInternetTitle = Localized.tr("Localizable", "error.no_internet_title")
    /// We can’t process this at the moment. Please try again later.
    internal static let routeUnavailableMessage = Localized.tr("Localizable", "error.route_unavailable_message")
    /// Your session has expired. Please log in again.
    internal static let sessionExpiredMessage = Localized.tr("Localizable", "error.session_expired_message")
    /// Session Expired
    internal static let sessionExpiredTitle = Localized.tr("Localizable", "error.session_expired_title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
