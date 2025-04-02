//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Provides functionality for extracting a color from an image.
public struct ImageColorClient: Sendable {
    private let extract: @Sendable (ImageRepresentable?) async -> Color?

    /// Creates a client that extracts a color from the given image.
    ///
    /// - Parameter extract: The closure to extract a color from the given image.
    public init(extract: @escaping @Sendable (ImageRepresentable?) async -> Color?) {
        self.extract = extract
    }

    /// Attempts to extract a color from the given image.
    public func callAsFunction(_ image: ImageRepresentable?) async -> Color? {
        await extract(image)
    }
}

// MARK: - Variants

extension ImageColorClient {
    /// Returns the noop variant of `ImageColorClient`.
    public static var noop: Self {
        .init { _ in nil }
    }

    /// Returns the unimplemented variant of `ImageColorClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.imageColor)"#)
            return nil
        }
    }

    /// Returns the live variant of `ImageColorClient`.
    public static var live: Self {
        .init { image in
            guard let image else {
                return nil
            }

            let uiImage = try? await UIImage.fetch(image)
            return uiImage?.averageColor.map(Color.init)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum ImageColorClientKey: DependencyKey {
        static let liveValue: ImageColorClient = .live
    }

    /// Provides functionality for extracting a color from an image.
    public var imageColor: ImageColorClient {
        get { self[ImageColorClientKey.self] }
        set { self[ImageColorClientKey.self] = newValue }
    }
}
