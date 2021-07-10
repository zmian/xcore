//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

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
