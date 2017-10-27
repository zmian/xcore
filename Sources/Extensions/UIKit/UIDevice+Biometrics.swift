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
    /// Indicates that the device owner can authenticate using biometry, Touch ID or Face ID.
    public var isBiometricsIDAvailable: Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// The types of biometric authentication supported.
    @available(iOS 11.0, *)
    public var biometryType: LABiometryType {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return .none
        }
        return context.biometryType
    }

    /// The name of the biometry authentication, "Touch ID" or "Face ID"; otherwise, an empty string.
    public var biometryName: String {
        if #available(iOS 11.0, *) {
            switch biometryType {
                case .none:
                    return ""
                case .typeTouchID:
                    return "Touch ID"
                case .typeFaceID:
                    return "Face ID"
            }
        } else {
            guard isBiometricsIDAvailable else { return "" }
            return "Touch ID"
        }
    }

    /// Face ID requires permission prompt. If user denies
    /// the permission, then `biometryType` returns `.none`.
    /// This property returns the actual capability of the device
    /// regardless of the permission status.
    @available(iOS 11.0, *)
    public var biometryCapabilityType: LABiometryType {
        guard biometryType == .none else {
            return biometryType
        }

        return DeviceType.iPhoneX ? .typeFaceID : .typeTouchID
    }

    /// Face ID requires permission prompt. If user denies
    /// the permission, then `biometryName` returns an empty string.
    /// This property returns the actual capability name of the device
    /// regardless of the permission status.
    public var biometryCapabilityName: String {
        guard biometryName.isEmpty else {
            return biometryName
        }

        return DeviceType.iPhoneX ? "Face ID" : "Touch ID"
    }
}
