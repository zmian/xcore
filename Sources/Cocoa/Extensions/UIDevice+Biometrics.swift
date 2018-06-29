//
// UIDevice+Biometrics.swift
//
// Copyright © 2017 Zeeshan Mian
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
import LocalAuthentication

extension UIDevice {
    public enum BiometryType {
        case none
        case touchID
        case faceID

        init(context: LAContext) {
            // There is a bug in the earlier versions of iOS 11 that causes crash
            // when accessing `LAContext.biometryType`. Guarding using `context.responds`
            // is a workaround for the devices running older iOS 11 versions.
            // This is fixed in the later version of iOS 11.
            guard #available(iOS 11.0, *), context.responds(to: #selector(getter: LAContext.biometryType)) else {
                self = UIDevice.current.isBiometricsIDAvailable ? .touchID : .none
                return
            }

            switch context.biometryType {
                case .touchID:
                    self = .touchID
                case .faceID:
                    self = .faceID
                default:
                    /// The device does not support biometry.
                    /// `LABiometryNone` introduced in `11.0` and was deprecated in `11.2`
                    /// and renamed to be `LABiometryType.none`.
                    /// This default case allows us to handle both of those cases without
                    /// resorting to hacks or explicit checks.
                    self = .none
            }
        }

        /// The name of the biometry authentication, "Touch ID" or "Face ID"; otherwise, an empty string.
        public var displayName: String {
            switch self {
                case .none:
                    return ""
                case .touchID:
                    return "Touch ID"
                case .faceID:
                    return "Face ID"
            }
        }
    }

    /// Indicates that the device owner can authenticate using biometry, Touch ID or Face ID.
    public var isBiometricsIDAvailable: Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// The types of biometric authentication supported.
    public var biometryType: BiometryType {
        let context = LAContext()

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return .none
        }

        return BiometryType(context: context)
    }

    /// Face ID requires permission prompt. If user denies
    /// the permission, then `biometryType` returns `.none`.
    /// This property returns the actual capability of the device
    /// regardless of the permission status.
    public var biometryCapabilityType: BiometryType {
        guard biometryType == .none else {
            return biometryType
        }

        return DeviceType.iPhoneX ? .faceID : .touchID
    }
}
