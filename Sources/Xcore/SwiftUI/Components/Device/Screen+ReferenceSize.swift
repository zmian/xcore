//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Screen {
    /// An enumeration that indicate the reference size.
    ///
    /// Sometime it is useful to know the screen size instead of a specific model
    /// as multiple devices share the same screen sizes (e.g., iPhone X and
    /// iPhone XS or iPhone 5, 5s, 5c & SE).
    public enum ReferenceSize {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case iPhoneXSMax
        case unknown

        init(screen: Screen) {
            switch screen.size.max {
                case 480:
                    self = .iPhone4
                case 568:
                    self = .iPhone5
                case 667:
                    self = .iPhone6
                case 736:
                    self = .iPhone6Plus
                case 812:
                    self = .iPhoneX
                case 896:
                    self = .iPhoneXSMax
                default:
                    self = .unknown
            }
        }

        public var size: CGSize {
            switch self {
                case .iPhone4:
                    return CGSize(width: 320, height: 480)
                case .iPhone5:
                    return CGSize(width: 320, height: 568)
                case .iPhone6:
                    return CGSize(width: 375, height: 667)
                case .iPhone6Plus:
                    return CGSize(width: 414, height: 736)
                case .iPhoneX:
                    return CGSize(width: 375, height: 812)
                case .iPhoneXSMax:
                    return CGSize(width: 414, height: 896)
                case .unknown:
                    return CGSize(width: -1, height: -1)
            }
        }

        /// A property indicating if this screen size is associated with iPhone X Series
        /// (e.g., iPhone X, iPhone Xs, iPhone Xs Max, iPhone Xʀ, iPhone 11,
        /// iPhone 11 Pro, iPhone 11 Pro Max).
        var iPhoneXSeries: Bool {
            switch self {
                case .iPhoneX, .iPhoneXSMax:
                    return true
                default:
                    return false
            }
        }
    }
}

// MARK: - Comparable

extension Screen.ReferenceSize: Comparable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.size.max == rhs.size.max && lhs.size.min == rhs.size.min
    }

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.size.max < rhs.size.max && lhs.size.min < rhs.size.min
    }
}
