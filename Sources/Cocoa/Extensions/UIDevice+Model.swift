//
// UIDevice+Extensions.swift
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
    /// A strongly typed current version of the operating system.
    ///
    /// ```swift
    /// // Strongly typed model type
    /// UIDevice.current.osVersion // e.g., "12.1"
    ///
    /// // Accurate version checks.
    /// if UIDevice.current.osVersion <= "7" {
    ///     // Less than or equal to iOS 7
    ///     ...
    /// }
    ///
    /// if UIDevice.current.osVersion > "8" {
    ///     // Greater than iOS 8
    ///     ...
    /// }
    ///
    /// // The current version of the operating system.
    /// var lessThanOrEqualToiOS12_1_3: Bool {
    ///     return UIDevice.current.osVersion <= "12.1.3"
    /// }
    ///
    /// if lessThanOrEqualToiOS12_1_3 {
    ///     // <= iOS 12.1.3
    ///     // Permanently disable Group FaceTime ;)
    ///     ...
    /// }
    /// ```
    public var osVersion: Version {
        return Version(rawValue: systemVersion)
    }
}

extension UIDevice {
    public enum ModelType: CustomStringConvertible {
        case unknown(String)
        case simulator

        // iPhone
        case iPhone2G
        case iPhone3G
        case iPhone3Gs
        case iPhone4, iPhone4s
        case iPhone5, iPhone5c, iPhone5s
        case iPhoneSE
        case iPhone6, iPhone6Plus
        case iPhone6s, iPhone6sPlus
        case iPhone7, iPhone7Plus
        case iPhone8, iPhone8Plus
        case iPhoneX
        case iPhoneXS
        case iPhoneXSMax
        case iPhoneXR

        // iPad
        case iPad_1
        case iPad_2
        case iPad_3
        case iPad_4
        case iPad_5
        case iPadMini_1
        case iPadMini_2
        case iPadMini_3
        case iPadMini_4
        case iPadAir_1
        case iPadAir_2
        case iPadPro97Inch
        case iPadPro10Inch
        case iPadPro11Inch
        case iPadPro12Inch_1
        case iPadPro12Inch_2
        case iPadPro12Inch_3

        // Apple Watch
        case appleWatchSeries0_38mm
        case appleWatchSeries0_42mm
        case appleWatchSeries1_38mm
        case appleWatchSeries1_42mm
        case appleWatchSeries2_38mm
        case appleWatchSeries2_42mm
        case appleWatchSeries3_38mm
        case appleWatchSeries3_42mm
        case appleWatchSeries4_40mm
        case appleWatchSeries4_44mm

        // Apple TV
        case appleTV1
        case appleTV2
        case appleTV3
        case appleTV4
        case appleTV4K

        // iPod
        case iPodTouch1
        case iPodTouch2
        case iPodTouch3
        case iPodTouch4
        case iPodTouch5
        case iPodTouch6

        // HomePod
        case homePod

        fileprivate init(identifier: String) {
            switch identifier {
                case "x86_64", "i386":
                    self = .simulator

                // iPhone

                case "iPhone1,1":
                    self = .iPhone2G
                case "iPhone1,2":
                    self = .iPhone3G
                case "iPhone2,1":
                    self = .iPhone3Gs
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":
                    self = .iPhone4
                case "iPhone4,1":
                    self = .iPhone4s
                case "iPhone5,1", "iPhone5,2":
                    self = .iPhone5
                case "iPhone5,3", "iPhone5,4":
                    self = .iPhone5c
                case "iPhone6,1", "iPhone6,2":
                    self = .iPhone5s
                case "iPhone8,4":
                    self = .iPhoneSE
                case "iPhone7,2":
                    self = .iPhone6
                case "iPhone7,1":
                    self = .iPhone6Plus
                case "iPhone8,1":
                    self = .iPhone6s
                case "iPhone8,2":
                    self = .iPhone6sPlus
                case "iPhone9,1", "iPhone9,3":
                    self = .iPhone7
                case "iPhone9,2", "iPhone9,4":
                    self = .iPhone7Plus
                case "iPhone10,1", "iPhone10,4":
                    self = .iPhone8
                case "iPhone10,2", "iPhone10,5":
                    self = .iPhone8Plus
                case "iPhone10,3", "iPhone10,6":
                    self = .iPhoneX
                case "iPhone11,2":
                    self = .iPhoneXS
                case "iPhone11,4", "iPhone11,6":
                    self = .iPhoneXSMax
                case "iPhone11,8":
                    self = .iPhoneXR

                // iPad

                case "iPad1,1", "iPad1,2":
                    self = .iPad_1
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                    self = .iPad_2
                case "iPad3,1", "iPad3,2", "iPad3,3":
                    self = .iPad_3
                case "iPad3,4", "iPad3,5", "iPad3,6":
                    self = .iPad_4
                case "iPad6,11", "iPad6,12":
                    self = .iPad_5
                case "iPad4,1", "iPad4,2", "iPad4,3":
                    self = .iPadAir_1
                case "iPad5,3", "iPad5,4":
                    self = .iPadAir_2
                case "iPad2,5", "iPad2,6", "iPad2,7":
                    self = .iPadMini_1
                case "iPad4,4", "iPad4,5", "iPad4,6":
                    self = .iPadMini_2
                case "iPad4,7", "iPad4,8", "iPad4,9":
                    self = .iPadMini_3
                case "iPad5,1", "iPad5,2":
                    self = .iPadMini_4
                case "iPad6,3", "iPad6,4":
                    self = .iPadPro97Inch
                case "iPad7,3", "iPad7,4":
                     self = .iPadPro10Inch
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
                    self = .iPadPro11Inch
                case "iPad6,7", "iPad6,8":
                    self = .iPadPro12Inch_1
                case "iPad7,1", "iPad7,2":
                    self = .iPadPro12Inch_2
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
                    self = .iPadPro12Inch_3

                // Apple Watch

                case "Watch1,1":
                    self = .appleWatchSeries0_38mm
                case "Watch1,2":
                    self = .appleWatchSeries0_42mm
                case "Watch2,6":
                    self = .appleWatchSeries1_38mm
                case "Watch2,7":
                    self = .appleWatchSeries1_42mm
                case "Watch2,3":
                    self = .appleWatchSeries2_38mm
                case "Watch2,4":
                    self = .appleWatchSeries2_42mm
                case "Watch3,1", "Watch3,3":
                    self = .appleWatchSeries3_38mm
                case "Watch3,2", "Watch3,4":
                    self = .appleWatchSeries3_42mm
                case "Watch4,1", "Watch4,3":
                    self = .appleWatchSeries4_40mm
                case "Watch4,2", "Watch4,4":
                    self = .appleWatchSeries4_44mm

                // Apple TV

                case "AppleTV1,1":
                    self = .appleTV1
                case "AppleTV2,1":
                    self = .appleTV2
                case "AppleTV3,1", "AppleTV3,2":
                    self = .appleTV3
                case "AppleTV5,3":
                    self = .appleTV4
                case "AppleTV6,2":
                    self = .appleTV4K

                // iPod

                case "iPod1,1":
                    self = .iPodTouch1
                case "iPod2,1":
                    self = .iPodTouch2
                case "iPod3,1":
                    self = .iPodTouch3
                case "iPod4,1":
                    self = .iPodTouch4
                case "iPod5,1":
                    self = .iPodTouch5
                case "iPod7,1":
                    self = .iPodTouch6

                // HomePod

                case "AudioAccessory1,1":
                    self = .homePod

                default:
                    self = .unknown(identifier)
            }
        }

        public var description: String {
            // swiftlint:disable switch_case_on_newline
            switch self {
                case .simulator:    return "Simulator"

                case .iPhone2G:     return "iPhone 2G"
                case .iPhone3G:     return "iPhone 3G"
                case .iPhone3Gs:    return "iPhone 3Gs"
                case .iPhone4:      return "iPhone 4"
                case .iPhone4s:     return "iPhone 4s"
                case .iPhone5:      return "iPhone 5"
                case .iPhone5c:     return "iPhone 5c"
                case .iPhone5s:     return "iPhone 5s"
                case .iPhoneSE:     return "iPhone SE"
                case .iPhone6:      return "iPhone 6"
                case .iPhone6Plus:  return "iPhone 6 Plus"
                case .iPhone6s:     return "iPhone 6s"
                case .iPhone6sPlus: return "iPhone 6s Plus"
                case .iPhone7:      return "iPhone 7"
                case .iPhone7Plus:  return "iPhone 7 Plus"
                case .iPhone8:      return "iPhone 8"
                case .iPhone8Plus:  return "iPhone 8 Plus"
                case .iPhoneX:      return "iPhone X"
                case .iPhoneXS:     return "iPhone XS"
                case .iPhoneXSMax:  return "iPhone XS Max"
                case .iPhoneXR:     return "iPhone XR"

                case .iPad_1:          return "iPad 1"
                case .iPad_2:          return "iPad 2"
                case .iPad_3:          return "iPad 3"
                case .iPad_4:          return "iPad 4"
                case .iPad_5:          return "iPad 5"
                case .iPadAir_1:       return "iPad Air"
                case .iPadAir_2:       return "iPad Air 2"
                case .iPadMini_1:      return "iPad Mini"
                case .iPadMini_2:      return "iPad Mini 2"
                case .iPadMini_3:      return "iPad Mini 3"
                case .iPadMini_4:      return "iPad Mini 4"
                case .iPadPro97Inch:   return "iPad Pro (9.7-inch)"
                case .iPadPro10Inch:   return "iPad Pro (10.5-inch)"
                case .iPadPro11Inch:   return "iPad Pro (11-inch)"
                case .iPadPro12Inch_1: return "iPad Pro (12.9-inch)"
                case .iPadPro12Inch_2: return "iPad Pro (12.9-inch) (2nd generation)"
                case .iPadPro12Inch_3: return "iPad Pro (12.9-inch) (3rd generation)"

                case .appleWatchSeries0_38mm: return "Apple Watch (1st generation) 38mm"
                case .appleWatchSeries0_42mm: return "Apple Watch (1st generation) 42mm"
                case .appleWatchSeries1_38mm: return "Apple Watch Series 1 38mm"
                case .appleWatchSeries1_42mm: return "Apple Watch Series 1 42mm"
                case .appleWatchSeries2_38mm: return "Apple Watch Series 2 38mm"
                case .appleWatchSeries2_42mm: return "Apple Watch Series 2 42mm"
                case .appleWatchSeries3_38mm: return "Apple Watch Series 3 38mm"
                case .appleWatchSeries3_42mm: return "Apple Watch Series 3 42mm"
                case .appleWatchSeries4_40mm: return "Apple Watch Series 4 40mm"
                case .appleWatchSeries4_44mm: return "Apple Watch Series 4 44mm"

                case .appleTV1:     return "Apple TV 1"
                case .appleTV2:     return "Apple TV 2"
                case .appleTV3:     return "Apple TV 3"
                case .appleTV4:     return "Apple TV 4"
                case .appleTV4K:    return "Apple TV 4K"

                case .iPodTouch1:   return "iPod Touch 1"
                case .iPodTouch2:   return "iPod Touch 2"
                case .iPodTouch3:   return "iPod Touch 3"
                case .iPodTouch4:   return "iPod Touch 4"
                case .iPodTouch5:   return "iPod Touch 5"
                case .iPodTouch6:   return "iPod Touch 6"

                case .homePod: return "HomePod"

                case .unknown(let identifier): return identifier
            }
            // swiftlint:enable switch_case_on_newline
        }
    }
}

extension UIDevice.ModelType {
    public enum Family: Equatable, CustomStringConvertible {
        case phone
        case pad
        case watch
        case tv
        case carPlay
        case pod
        case simulator
        case unknown

        fileprivate init(device: UIDevice, identifier: String) {
            #if targetEnvironment(simulator)
                self = .simulator
            #endif

            if identifier.starts(with: "Watch") {
                self = .watch
            }

            if identifier.starts(with: "iPod") {
                self = .pod
            }

            switch device.userInterfaceIdiom {
                case .phone:
                    self = .phone
                case .pad:
                    self = .pad
                case .tv:
                    self = .tv
                case .carPlay:
                    self = .carPlay
                case .unspecified:
                    self = .unknown
                @unknown default:
                    #if DEBUG
                    fatalError(because: .unknownCaseDetected(device.userInterfaceIdiom))
                    #else
                    self = .unknown
                    #endif
            }
        }

        public var description: String {
            switch self {
                case .phone:
                    return "iPhone"
                case .pad:
                    return "iPad"
                case .watch:
                    return "Apple Watch"
                case .tv:
                    return "Apple TV"
                case .carPlay:
                    return "CarPlay"
                case .pod:
                    return "iPod"
                case .simulator:
                    return "Simulator"
                case .unknown:
                    return "Unknown"
            }
        }
    }
}

extension UIDevice.ModelType {
    public enum ScreenSize {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case iPhoneXSMax
        case unknown

        fileprivate init() {
            switch UIScreen.main.bounds.size.max {
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
        /// (e.g., iPhone X, iPhone XS, iPhone XS Max, iPhone XR).
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

extension UIDevice.ModelType.ScreenSize: Comparable {
    private static var iPhone: Bool {
        return UIDevice.current.modelType.family == .phone
    }

    public static func ==(lhs: UIDevice.ModelType.ScreenSize, rhs: UIDevice.ModelType.ScreenSize) -> Bool {
        return iPhone && lhs.size.max == rhs.size.max && lhs.size.min == rhs.size.min
    }

    public static func <(lhs: UIDevice.ModelType.ScreenSize, rhs: UIDevice.ModelType.ScreenSize) -> Bool {
        return iPhone && lhs.size.max < rhs.size.max && lhs.size.min < rhs.size.min
    }
}

extension UIDevice.ModelType {
    /// The model identifier of the current device (e.g., `iPhone9,2`).
    public var identifier: String {
        return UIDevice.identifier
    }

    /// The family name of the current device (e.g., iPhone or Apple TV).
    public var family: Family {
        return Family(device: UIDevice.current, identifier: identifier)
    }

    /// The screen size associated with the model.
    ///
    /// Sometime it is useful to know the screen size instead of a specific model
    /// as multiple devices share the same screen sizes (e.g., iPhone X and
    /// iPhone XS or iPhone 5, 5s, 5c & SE).
    public var screenSize: ScreenSize {
        return ScreenSize()
    }
}

extension UIDevice {
    /// A strongly typed model type of the current device.
    ///
    /// ```swift
    /// // Strongly typed model type
    /// UIDevice.current.modelType // e.g., ModelType.iPhone7Plus
    ///
    /// // User-friendly device name
    /// print(UIDevice.current.modelType) // iPhone 7 Plus
    ///
    /// // Compile-time safe conditional check
    /// if UIDevice.current.modelType == .iPhone7Plus {
    ///     ...
    /// }
    ///
    /// print(UIDevice.current.modelType.family) // iPhone
    ///
    /// // Compile-time safe conditional check
    /// if UIDevice.current.modelType.family == .phone {
    ///     ...
    /// }
    /// ```
    public var modelType: ModelType {
        return ModelType(identifier: UIDevice.identifier)
    }

    /// The model identifier of the current device (e.g., `iPhone9,2`).
    fileprivate static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children {
            if let value = child.value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }

        return identifier
    }
}
