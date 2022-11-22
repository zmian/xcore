//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Provides functionality for extracting a color from an image.
public struct ImageColorClient {
    private let extract: (ImageRepresentable?) async -> Color?

    /// Creates a client that extracts a color from the given image.
    ///
    /// - Parameter extract: The closure to extract a color from the given image.
    public init(extract: @escaping (ImageRepresentable?) async -> Color?) {
        self.extract = extract
    }

    /// Attempts to extract a color from the given image.
    public func callAsFunction(_ image: ImageRepresentable?) async -> Color? {
        await extract(image)
    }
}

// MARK: - Variants

extension ImageColorClient {
    /// Returns noop variant of `ImageColorClient`.
    public static var noop: Self {
        .init { _ in nil }
    }

    #if DEBUG
    /// Returns unimplemented variant of `ImageColorClient`.
    public static var unimplemented: Self {
        .init { _ in
            internal_XCTFail("\(Self.self) is unimplemented")
            return nil
        }
    }
    #endif

    /// Returns live variant of `ImageColorClient`.
    public static var live: Self {
        .init { image in
            guard let image else {
                return nil
            }

            return await withCheckedContinuation { continuation in
                UIImage.fetch(image) { result in
                    let uiColor = result.value?.averageColor
                    continuation.resume(returning: uiColor.map(Color.init))
                }
            }
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct ImageColorClientKey: DependencyKey {
        static let liveValue: ImageColorClient = .live
    }

    /// Provides functionality for extracting a color from an image.
    public var imageColor: ImageColorClient {
        get { self[ImageColorClientKey.self] }
        set { self[ImageColorClientKey.self] = newValue }
    }
}
