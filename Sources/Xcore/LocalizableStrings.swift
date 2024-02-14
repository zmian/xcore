// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localized {
  /// Cancel
  internal static let cancel = Localized.tr("Localizable", "cancel", fallback: "Cancel")
  /// Contact Support
  internal static let contactSupport = Localized.tr("Localizable", "contact_support", fallback: "Contact Support")
  /// Continue
  internal static let `continue` = Localized.tr("Localizable", "continue", fallback: "Continue")
  /// Done
  internal static let done = Localized.tr("Localizable", "done", fallback: "Done")
  /// Enable
  internal static let enable = Localized.tr("Localizable", "enable", fallback: "Enable")
  /// Get Started
  internal static let getStarted = Localized.tr("Localizable", "get_started", fallback: "Get Started")
  /// Help
  internal static let help = Localized.tr("Localizable", "help", fallback: "Help")
  /// Hide
  internal static let hide = Localized.tr("Localizable", "hide", fallback: "Hide")
  /// Learn More
  internal static let learnMore = Localized.tr("Localizable", "learn_more", fallback: "Learn More")
  /// Next
  internal static let next = Localized.tr("Localizable", "next", fallback: "Next")
  /// No
  internal static let no = Localized.tr("Localizable", "no", fallback: "No")
  /// OK
  internal static let ok = Localized.tr("Localizable", "ok", fallback: "OK")
  /// Open App Settings
  internal static let openAppSettings = Localized.tr("Localizable", "open_app_settings", fallback: "Open App Settings")
  /// Open Mail App
  internal static let openMailApp = Localized.tr("Localizable", "open_mail_app", fallback: "Open Mail App")
  /// Read More
  internal static let readMore = Localized.tr("Localizable", "read_more", fallback: "Read More")
  /// Remove
  internal static let remove = Localized.tr("Localizable", "remove", fallback: "Remove")
  /// Resend
  internal static let resend = Localized.tr("Localizable", "resend", fallback: "Resend")
  /// Plural format key: "You can resend in %1$#@seconds@"
  internal static func resendAfter(_ p1: Int) -> String {
    return Localized.tr("Localizable", "resend_after", p1, fallback: "Plural format key: \"You can resend in %1$#@seconds@\"")
  }
  /// Retry
  internal static let retry = Localized.tr("Localizable", "retry", fallback: "Retry")
  /// See All
  internal static let seeAll = Localized.tr("Localizable", "see_all", fallback: "See All")
  /// See More
  internal static let seeMore = Localized.tr("Localizable", "see_more", fallback: "See More")
  /// Share
  internal static let share = Localized.tr("Localizable", "share", fallback: "Share")
  /// Log In
  internal static let signin = Localized.tr("Localizable", "signin", fallback: "Log In")
  /// Sign Up
  internal static let signup = Localized.tr("Localizable", "signup", fallback: "Sign Up")
  /// Start
  internal static let start = Localized.tr("Localizable", "start", fallback: "Start")
  /// Submit
  internal static let submit = Localized.tr("Localizable", "submit", fallback: "Submit")
  /// See All
  internal static let toggleSeeAll = Localized.tr("Localizable", "toggle_see_all", fallback: "See All")
  /// See Less
  internal static let toggleSeeLess = Localized.tr("Localizable", "toggle_see_less", fallback: "See Less")
  /// See More
  internal static let toggleSeeMore = Localized.tr("Localizable", "toggle_see_more", fallback: "See More")
  /// Track
  internal static let track = Localized.tr("Localizable", "track", fallback: "Track")
  /// Unlink
  internal static let unlink = Localized.tr("Localizable", "unlink", fallback: "Unlink")
  /// Unlock
  internal static let unlock = Localized.tr("Localizable", "unlock", fallback: "Unlock")
  /// Yes
  internal static let yes = Localized.tr("Localizable", "yes", fallback: "Yes")
  internal enum Error {
    /// From your device settings, enable camera access.
    internal static let cameraPermissionDeniedMessage = Localized.tr("Localizable", "error.camera_permission_denied_message", fallback: "From your device settings, enable camera access.")
    /// Camera Permission Denied
    internal static let cameraPermissionDeniedTitle = Localized.tr("Localizable", "error.camera_permission_denied_title", fallback: "Camera Permission Denied")
    /// Seems there is an issue with your device camera.
    internal static let cameraUnavailableMessage = Localized.tr("Localizable", "error.camera_unavailable_message", fallback: "Seems there is an issue with your device camera.")
    /// Camera Unavailable
    internal static let cameraUnavailableTitle = Localized.tr("Localizable", "error.camera_unavailable_title", fallback: "Camera Unavailable")
    /// We’ll get this fixed as soon as we can. Please contact support for more information.
    internal static let databaseErrorMessage = Localized.tr("Localizable", "error.database_error_message", fallback: "We’ll get this fixed as soon as we can. Please contact support for more information.")
    /// We can’t process this at the moment. Please try again later.
    internal static let generalErrorMessage = Localized.tr("Localizable", "error.general_error_message", fallback: "We can’t process this at the moment. Please try again later.")
    /// Something Went Wrong
    internal static let generalErrorTitle = Localized.tr("Localizable", "error.general_error_title", fallback: "Something Went Wrong")
    /// Please complete all information before continuing.
    internal static let generalMissingFieldsMessage = Localized.tr("Localizable", "error.general_missing_fields_message", fallback: "Please complete all information before continuing.")
    /// Missing Information
    internal static let generalMissingFieldsTitle = Localized.tr("Localizable", "error.general_missing_fields_title", fallback: "Missing Information")
    /// Please check your internet connection and try again.
    internal static let noInternetMessage = Localized.tr("Localizable", "error.no_internet_message", fallback: "Please check your internet connection and try again.")
    /// No Internet Connection
    internal static let noInternetTitle = Localized.tr("Localizable", "error.no_internet_title", fallback: "No Internet Connection")
    /// We can’t process this at the moment. Please try again later.
    internal static let routeUnavailableMessage = Localized.tr("Localizable", "error.route_unavailable_message", fallback: "We can’t process this at the moment. Please try again later.")
    /// Your session has expired. Please log in again to continue.
    internal static let sessionExpiredMessage = Localized.tr("Localizable", "error.session_expired_message", fallback: "Your session has expired. Please log in again to continue.")
    /// Session Expired
    internal static let sessionExpiredTitle = Localized.tr("Localizable", "error.session_expired_title", fallback: "Session Expired")
  }
  internal enum MailApp {
    /// Choose Your Mail App
    internal static let `open` = Localized.tr("Localizable", "mail_app.open", fallback: "Choose Your Mail App")
  }
  internal enum PostalAddress {
    /// Please make sure the address is valid and includes a street name and number.
    internal static let invalid = Localized.tr("Localizable", "postal_address.invalid", fallback: "Please make sure the address is valid and includes a street name and number.")
    internal enum InvalidPoBox {
      /// Please enter an address that doesn’t correspond to a P.O. Box.
      internal static let message = Localized.tr("Localizable", "postal_address.invalid_po_box.message", fallback: "Please enter an address that doesn’t correspond to a P.O. Box.")
      /// Residential Address
      internal static let title = Localized.tr("Localizable", "postal_address.invalid_po_box.title", fallback: "Residential Address")
    }
    internal enum InvalidRegion {
      /// %@ is currently available to only %@ residents. To continue, please enter your residential address in one of the supported regions.
      internal static func messageFew(_ p1: Any, _ p2: Any) -> String {
        return Localized.tr("Localizable", "postal_address.invalid_region.message_few", String(describing: p1), String(describing: p2), fallback: "%@ is currently available to only %@ residents. To continue, please enter your residential address in one of the supported regions.")
      }
      /// %@ is currently not available in your region.
      internal static func messageMany(_ p1: Any) -> String {
        return Localized.tr("Localizable", "postal_address.invalid_region.message_many", String(describing: p1), fallback: "%@ is currently not available in your region.")
      }
      /// %@ is currently available to %@ residents. To continue, please enter your %@ residential address.
      internal static func messageOne(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
        return Localized.tr("Localizable", "postal_address.invalid_region.message_one", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "%@ is currently available to %@ residents. To continue, please enter your %@ residential address.")
      }
      /// %@ Addresses
      internal static func titleOne(_ p1: Any) -> String {
        return Localized.tr("Localizable", "postal_address.invalid_region.title_one", String(describing: p1), fallback: "%@ Addresses")
      }
      /// Unsupported Region
      internal static let titleOther = Localized.tr("Localizable", "postal_address.invalid_region.title_other", fallback: "Unsupported Region")
    }
  }
  internal enum PushNotifications {
    internal enum OpenSystemSettings {
      /// Open Settings
      internal static let buttonOpenSettings = Localized.tr("Localizable", "push_notifications.open_system_settings.button_open_settings", fallback: "Open Settings")
      /// In Settings, tap Notifications and switch on Allow Notifications.
      internal static let message = Localized.tr("Localizable", "push_notifications.open_system_settings.message", fallback: "In Settings, tap Notifications and switch on Allow Notifications.")
      /// Open Settings
      internal static let title = Localized.tr("Localizable", "push_notifications.open_system_settings.title", fallback: "Open Settings")
    }
  }
  internal enum Signout {
    /// Log Out
    internal static let title = Localized.tr("Localizable", "signout.title", fallback: "Log Out")
    internal enum ConfirmPopup {
      /// Are you sure you would like to log out?
      internal static let message = Localized.tr("Localizable", "signout.confirm_popup.message", fallback: "Are you sure you would like to log out?")
      /// Log Out
      internal static let title = Localized.tr("Localizable", "signout.confirm_popup.title", fallback: "Log Out")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
