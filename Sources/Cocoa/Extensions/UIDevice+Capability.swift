//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIDevice {
    /// A type to return the capabilities of the device.
    public struct Capability: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// - SeeAlso: `UIDevice.current.biometrics.isAvailable` and `UIDevice.current.biometrics.kind`.
        public static let touchID = Capability(rawValue: 1 << 0)
        /// - SeeAlso: `UIDevice.current.biometrics.isAvailable` and `UIDevice.current.biometrics.kind`.
        public static let faceID = Capability(rawValue: 1 << 1)
        public static let notch = Capability(rawValue: 1 << 2)
        public static let homeIndicator = Capability(rawValue: 1 << 3)
        public static let iPhoneXSeries: Capability = [.notch, .faceID, .homeIndicator]
    }
}

extension UIDevice {
    public var capability: Capability {
        var capability: Capability = []

        if hasTopNotch {
            capability.update(with: .notch)
        }

        if hasHomeIndicator {
            capability.update(with: .homeIndicator)
        }

        switch biometrics.kind {
            case .touchID:
                capability.update(with: .touchID)
            case .faceID:
                capability.update(with: .faceID)
            case .none:
                break
        }

        return capability
    }
}

extension UIDevice {
    private var hasTopNotch: Bool {
        // Notch: 44 on iPhone X, XS, XS Max, XR.
        // No Notch: 24 on iPad Pro 12.9" 3rd generation, 20 on iPhone 8
        UIApplication.sharedOrNil?.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }

    private var hasHomeIndicator: Bool {
        // Home indicator: 34 on iPhone X, XS, XS Max, XR.
        // Home indicator: 20 on iPad Pro 12.9" 3rd generation.
        UIApplication.sharedOrNil?.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
}
