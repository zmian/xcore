//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - SystemAssetIdentifier

extension Label where Title == Text, Icon == Image {
    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - systemImage: The name of the image resource to lookup.
    public init(_ titleKey: LocalizedStringKey, systemImage: SystemAssetIdentifier) {
        self.init(titleKey, systemImage: systemImage.rawValue)
    }

    /// Creates a label with a system icon image and a title generated from a
    /// string.
    ///
    /// - Parameters:
    ///    - title: A string to used as the label's title.
    ///    - systemImage: The name of the image resource to lookup.
    public init<S>(_ title: S, systemImage: SystemAssetIdentifier) where S: StringProtocol {
        self.init(title, systemImage: systemImage.rawValue)
    }
}

// MARK: - ImageAssetIdentifier

extension Label where Title == Text, Icon == Image {
    /// Creates a label with an icon image and a title generated from a localized
    /// string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    public init(_ titleKey: LocalizedStringKey, image: ImageAssetIdentifier) {
        self.init(titleKey, image: Image(assetIdentifier: image))
    }

    /// Creates a label with an icon image and a title generated from a string.
    ///
    /// - Parameters:
    ///    - title: A string to used as the label's title.
    ///    - image: The name of the image resource to lookup.
    public init<S>(_ title: S, image: ImageAssetIdentifier) where S: StringProtocol {
        self.init(title, image: Image(assetIdentifier: image))
    }
}

// MARK: - Image

extension Label where Title == Text, Icon == Image {
    /// Creates a label with an icon image and a title generated from a localized
    /// string.
    ///
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///    - image: The image.
    public init(_ titleKey: LocalizedStringKey, image: Image) {
        self.init { Text(titleKey) } icon: { image }
    }

    /// Creates a label with an icon image and a title generated from a string.
    ///
    /// - Parameters:
    ///    - title: A string to used as the label's title.
    ///    - image: The image.
    public init<S>(_ title: S, image: Image) where S: StringProtocol {
        self.init { Text(title) } icon: { image }
    }
}
