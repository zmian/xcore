//
// UIDevice+Capability.swift
//
// Copyright © 2014 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

extension UIDevice {
    /// A type to return the capabilities of the device.
    public struct Capability: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// - SeeAlso: `UIDevice.current.isBiometricsIdAvailable` and `UIDevice.current.biometryCapabilityType`.
        public static let touchID = Capability(rawValue: 1 << 0)
        /// - SeeAlso: `UIDevice.current.isBiometricsIdAvailable` and `UIDevice.current.biometryCapabilityType`.
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

        switch biometryCapabilityType {
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
        return UIApplication.sharedOrNil?.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }

    private var hasHomeIndicator: Bool {
        // Home indicator: 34 on iPhone X, XS, XS Max, XR.
        // Home indicator: 20 on iPad Pro 12.9" 3rd generation.
        return UIApplication.sharedOrNil?.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
}
