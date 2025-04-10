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
            let data = string.data(using: .ascii)
            let context = CIContext()
            let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]

            let qrFilter = CIFilter.qrCodeGenerator().apply {
                $0.setValue(data, forKey: "inputMessage")
            }

            guard
                let qrImage = qrFilter.outputImage,
                let cgImage = context.createCGImage(qrImage, from: qrImage.extent),
                let transparentImage = cgImage.copy(maskingColorComponents: colorMasking)
            else {
                throw AppError.qrCodeGenerationFailed
            }

            return UIImage(cgImage: transparentImage)
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
