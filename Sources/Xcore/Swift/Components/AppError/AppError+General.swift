//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - General

extension AppError {
    /// An error with general title and message.
    ///
    /// It is appropriate to use this error when no specific error can be thrown.
    ///
    /// ```
    /// // Something went wrong
    /// // We can’t process this at the moment. Please try again later.
    /// ```
    public static var general: Self {
        .init(
            id: #function.snakecased(),
            title: L.generalErrorTitle,
            message: L.generalErrorMessage
        )
    }

    /// ```
    /// // Please fill in all fields
    /// // You may have missed some required fields.
    /// ```
    public static var missingFields: Self {
        .init(
            id: #function.snakecased(),
            title: L.generalMissingFieldsTitle,
            message: L.generalMissingFieldsMessage
        )
    }
}

// MARK: - No Internet

extension AppError {
    /// An error thrown when a device is offline.
    ///
    /// ```
    /// // No Internet Connection
    /// // Please check your internet connection and try again.
    /// ```
    public static var noInternet: Self {
        .init(
            id: #function.snakecased(),
            title: L.noInternetTitle,
            message: L.noInternetMessage
        )
    }
}

// MARK: - Router

extension AppError {
    /// An error thrown when a deeplink route is unavailable.
    ///
    /// ```
    /// // Something went wrong
    /// // We can’t process this at the moment. Please try again later.
    /// ```
    public static var routeUnavailable: Self {
        .init(
            id: #function.snakecased(),
            title: L.generalErrorTitle,
            message: L.routeUnavailableMessage
        )
    }
}

// MARK: - Database

extension AppError {
    /// ```
    /// // Something went wrong
    /// // We’ll get this fixed as soon as we can. Please contact support for more
    /// // information.
    /// ```
    public static var database: Self {
        .init(
            id: #function.snakecased(),
            title: L.generalErrorTitle,
            message: L.databaseErrorMessage,
            logLevel: .critical
        )
    }

    /// ```
    /// // Something went wrong
    /// // We’ll get this fixed as soon as we can. Please contact support for more
    /// // information.
    /// ```
    public static var databaseConnectionFailed: Self {
        .init(
            id: #function.snakecased(),
            title: L.generalErrorTitle,
            message: L.databaseErrorMessage,
            logLevel: .critical
        )
    }
}

// MARK: - Encoding & Decoding

extension AppError {
    /// An error thrown when encoding fails.
    ///
    /// ```
    /// // Something went wrong
    /// // <message>
    /// ```
    public static func encodingFailed(message: String) -> Self {
        .init(
            id: "encoding_failed",
            title: L.generalErrorTitle,
            message: message,
            logLevel: .error
        )
    }

    /// An error thrown when decoding fails.
    ///
    /// ```
    /// // Something went wrong
    /// // <message>
    /// ```
    public static func decodingFailed(message: String) -> Self {
        .init(
            id: "decoding_failed",
            title: L.generalErrorTitle,
            message: message,
            logLevel: .error
        )
    }

    /// An error thrown when decoding fails due to invalid data.
    ///
    /// ```
    /// // Something went wrong
    /// // We can’t process this at the moment. Please try again later.
    /// ```
    public static func decodingFailedInvalidData(file: StaticString = #fileID, line: UInt = #line) -> Self {
        .init(
            id: "decoding_failed",
            title: L.generalErrorTitle,
            message: L.generalErrorMessage,
            debugMessage: "\(file):\(line) Invalid data",
            logLevel: .error
        )
    }
}

// MARK: - Auth

extension AppError {
    /// An error thrown when user's session expires.
    public static var authSessionExpired: Self { sessionExpired() }
    public static var authAccessTokenNotFound: Self { sessionExpired() }
    public static var authRefreshTokenNotFound: Self { sessionExpired() }

    /// An error thrown when user's session expires.
    ///
    /// ```
    /// // Session Expired
    /// // Your session has expired. Please log in again.
    /// ```

    /// Returns a new instance with updated `id` and all other properties are same
    /// as `sessionExpired` error.
    private static func sessionExpired(_ id: String = #function) -> Self {
        .init(
            id: id.snakecased(),
            title: L.sessionExpiredTitle,
            message: L.sessionExpiredMessage
        )
    }
}

// MARK: - Misc

extension AppError {
    public static var invalidUrl: Self { propertyName() }
    public static var qrCodeGenerationFailed: Self { propertyName() }
}

// MARK: - Camera

extension AppError {
    /// An error thrown when device camera isn't available.
    ///
    /// ```
    /// // Camera unavailable
    /// // Seems there is an issue with your device camera.
    /// ```
    public static var cameraUnavailable: Self {
        .init(
            id: #function.snakecased(),
            title: L.cameraUnavailableTitle,
            message: L.cameraUnavailableMessage
        )
    }

    /// An error thrown when device camera permission was denied.
    ///
    /// ```
    /// // Camera permission denied
    /// // In settings, switch on Camera to enable it.
    /// ```
    public static var cameraPermissionDenied: Self {
        .init(
            id: #function.snakecased(),
            title: L.cameraPermissionDeniedTitle,
            message: L.cameraPermissionDeniedMessage
        )
    }
}
