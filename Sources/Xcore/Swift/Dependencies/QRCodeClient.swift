//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit
private import CoreImage.CIFilterBuiltins

/// Provides functionality for generating a QR code.
public struct QRCodeClient: Sendable {
    /// Attempts to generate a QR code of the given string.
    public let generate: @Sendable (String) throws -> UIImage

    /// Creates a client that generates a QR code of the given string.
    ///
    /// - Parameter generate: The closure to generate a QR code of the given string.
    public init(generate: @escaping @Sendable (String) throws -> UIImage) {
        self.generate = generate
    }
}

// MARK: - Variants

extension QRCodeClient {
    /// Returns the noop variant of `QRCodeClient`.
    public static var noop: Self {
        .init { _ in UIImage() }
    }

    /// Returns the unimplemented variant of `QRCodeClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.qrCode)"#)
            throw CancellationError()
        }
    }

    /// Returns the live variant of `QRCodeClient`.
    public static var live: Self {
        .init { string in
            let qrFilter = CIFilter.qrCodeGenerator().apply {
                $0.message = Data(string.utf8)
            }

            guard let qrImage = qrFilter.outputImage else {
                throw AppError.qrCodeGenerationFailed
            }

            // Apply false color filter to make qr background transparent
            let colorFilter = CIFilter.falseColor().apply {
                $0.setValue(qrImage, forKey: kCIInputImageKey)
                // QR code color
                $0.setValue(CIColor.black, forKey: "inputColor0")
                // Transparent background
                $0.setValue(CIColor.clear, forKey: "inputColor1")
            }

            guard let outputImage = colorFilter.outputImage else {
                throw AppError.qrCodeGenerationFailed
            }

            guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
                throw AppError.qrCodeGenerationFailed
            }

            return UIImage(cgImage: cgImage)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum QRCodeClientKey: DependencyKey {
        static let liveValue: QRCodeClient = .live
    }

    /// Provides functionality for generating a QR code.
    public var qrCode: QRCodeClient {
        get { self[QRCodeClientKey.self] }
        set { self[QRCodeClientKey.self] = newValue }
    }
}
#endif
