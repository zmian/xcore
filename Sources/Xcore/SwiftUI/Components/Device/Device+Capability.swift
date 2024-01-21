//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Device {
    /// A structure representing the device’s capabilities.
    public struct Capability: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// - SeeAlso: `Device.current.biometrics.isAvailable` and `Device.current.biometrics.kind`.
        public static let touchID = Capability(rawValue: 1 << 0)
        /// - SeeAlso: `Device.current.biometrics.isAvailable` and `Device.current.biometrics.kind`.
        public static let faceID = Capability(rawValue: 1 << 1)
        public static let opticID = Capability(rawValue: 1 << 2)
        public static let notch = Capability(rawValue: 1 << 3)
        public static let homeIndicator = Capability(rawValue: 1 << 4)
        public static let iPhoneXSeries: Capability = [.notch, .faceID, .opticID, .homeIndicator]
    }
}

extension Device {
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
            case .opticID:
                capability.update(with: .opticID)
            case .none:
                break
        }

        return capability
    }
}

extension Device {
    private var hasTopNotch: Bool {
        // Notch: 44 on iPhone X, XS, XS Max, XR.
        // No Notch: 24 on iPad Pro 12.9" 3rd generation, 20 on iPhone 8
        AppConstants.statusBarHeight > 24
    }

    private var hasHomeIndicator: Bool {
        let safeAreaInsets = UIApplication
            .sharedOrNil?
            .firstSceneKeyWindow?
            .safeAreaInsets

        // Home indicator: 34 on iPhone X, XS, XS Max, XR.
        // Home indicator: 20 on iPad Pro 12.9" 3rd generation.
        return safeAreaInsets?.bottom ?? 0 > 0
    }
}
