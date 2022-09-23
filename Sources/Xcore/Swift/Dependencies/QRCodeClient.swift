//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
@_implementationOnly import CoreImage.CIFilterBuiltins

/// Provides functionality for generating a QR code.
public struct QRCodeClient {
    /// Attempts to generate a QR code of the given string.
    public let generate: (String) throws -> UIImage

    /// Creates a client that generates a QR code of the given string.
    ///
    /// - Parameter generate: The closure to generate a QR code of the given string.
    public init(generate: @escaping (String) throws -> UIImage) {
        self.generate = generate
    }
}

// MARK: - Variants

extension QRCodeClient {
    /// Returns noop variant of `QRCodeClient`.
    public static var noop: Self {
        .init { _ in UIImage() }
    }

    #if DEBUG
    /// Returns unimplemented variant of `QRCodeClient`.
    public static var unimplemented: Self {
        .init { _ in
            internal_XCTFail("\(Self.self).generate is unimplemented")
            return UIImage()
        }
    }
    #endif

    /// Returns live variant of `QRCodeClient`.
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
    private struct QRCodeClientKey: DependencyKey {
        static let defaultValue: QRCodeClient = .live
    }

    /// Provides functionality for generating a QR code.
    public var qrCode: QRCodeClient {
        get { self[QRCodeClientKey.self] }
        set { self[QRCodeClientKey.self] = newValue }
    }

    /// Provides functionality for generating a QR code.
    @discardableResult
    public static func qrCode(_ value: QRCodeClient) -> Self.Type {
        self[\.qrCode] = value
        return Self.self
    }
}
