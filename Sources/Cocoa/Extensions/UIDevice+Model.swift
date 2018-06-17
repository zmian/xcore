//
// UIDevice+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

        // iPad
        case iPad1
        case iPad2, iPad3, iPad4
        case iPadMini, iPadMini2, iPadMini3, iPadMini4
        case iPadAir, iPadAir2
        case iPad5
        case iPadPro97
        case iPadPro10
        case iPadPro12

        // Apple Watch
        case appleWatch38
        case appleWatch42
        case appleWatchSeries138
        case appleWatchSeries142
        case appleWatchSeries238
        case appleWatchSeries242

        // Apple TV
        case appleTV1
        case appleTV2
        case appleTV3
        case appleTV4

        // iPod
        case iPodTouch1
        case iPodTouch2
        case iPodTouch3
        case iPodTouch4
        case iPodTouch5

        fileprivate init(modelNumber identifier: String) {
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

                // iPad

                case "iPad1,1", "iPad1,2":
                    self = .iPad1
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                    self = .iPad2
                case "iPad3,1", "iPad3,2", "iPad3,3":
                    self = .iPad3
                case "iPad3,4", "iPad3,5", "iPad3,6":
                    self = .iPad4
                case "iPad4,1", "iPad4,2", "iPad4,3":
                    self = .iPadAir
                case "iPad5,3", "iPad5,4":
                    self = .iPadAir2
                case "iPad2,5", "iPad2,6", "iPad2,7":
                    self = .iPadMini
                case "iPad4,4", "iPad4,5", "iPad4,6":
                    self = .iPadMini2
                case "iPad4,7", "iPad4,8", "iPad4,9":
                    self = .iPadMini3
                case "iPad5,1", "iPad5,2":
                    self = .iPadMini4
                case "iPad6,3", "iPad6,4":
                    self = .iPadPro97
                case "iPad6,11", "iPad6,12":
                     self = .iPad5
                case "iPad7,3", "iPad7,4":
                     self = .iPadPro10
                case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2":
                    self = .iPadPro12

                // Apple Watch

                case "Watch1,1":
                    self = .appleWatch38
                case "Watch1,2":
                    self = .appleWatch42
                case "Watch2,6":
                    self = .appleWatchSeries138
                case "Watch2,7":
                    self = .appleWatchSeries142
                case "Watch2,3":
                    self = .appleWatchSeries238
                case "Watch2,4":
                    self = .appleWatchSeries242

                // Apple TV

                case "AppleTV1,1":
                    self = .appleTV1
                case "AppleTV2,1":
                    self = .appleTV2
                case "AppleTV3,1", "AppleTV3,2":
                    self = .appleTV3
                case "AppleTV5,3":
                    self = .appleTV4

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

                default:
                    self = .unknown(identifier)
            }
        }

        public var description: String {
            // swiftlint:disable case_return_new_line
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

                case .iPad1:        return "iPad 1"
                case .iPad2:        return "iPad 2"
                case .iPad3:        return "iPad 3"
                case .iPad4:        return "iPad 4"
                case .iPadAir:      return "iPad Air"
                case .iPadAir2:     return "iPad Air 2"
                case .iPadMini:     return "iPad Mini"
                case .iPadMini2:    return "iPad Mini 2"
                case .iPadMini3:    return "iPad Mini 3"
                case .iPadMini4:    return "iPad Mini 4"
                case .iPad5:        return "iPad 5"
                case .iPadPro97:    return "iPad Pro 9.7"
                case .iPadPro10:    return "iPad Pro 10.5"
                case .iPadPro12:    return "iPad Pro 12.9"

                case .appleWatch38: return "Apple Watch 38"
                case .appleWatch42: return "Apple Watch 42"
                case .appleWatchSeries138: return "Apple Watch Series 1 38"
                case .appleWatchSeries142: return "Apple Watch Series 1 42"
                case .appleWatchSeries238: return "Apple Watch Series 2 38"
                case .appleWatchSeries242: return "Apple Watch Series 2 42"

                case .appleTV1:     return "Apple TV 1"
                case .appleTV2:     return "Apple TV 2"
                case .appleTV3:     return "Apple TV 3"
                case .appleTV4:     return "Apple TV 4"

                case .iPodTouch1:   return "iPod Touch 1"
                case .iPodTouch2:   return "iPod Touch 2"
                case .iPodTouch3:   return "iPod Touch 3"
                case .iPodTouch4:   return "iPod Touch 4"
                case .iPodTouch5:   return "iPod Touch 5"

                case .unknown(let identifier): return identifier
            }
            // swiftlint:enable case_return_new_line
        }
    }

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
    /// ```
    public var modelType: ModelType {
        return ModelType(modelNumber: modelNumber)
    }

    /// The model number of the current device (e.g., `iPhone9,2`).
    public var modelNumber: String {
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

    /// The family name of the current device (e.g., Apple TV or iPhone).
    public var modelFamilyName: String {
        if UIDevice.DeviceType.Simulator {
            return "Simulator"
        }

        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return "iPhone"
            case .pad:
                return "iPad"
            case .tv:
                return "Apple TV"
            case .carPlay:
                return "CarPlay"
            case .unspecified:
                return "Unknown"
        }
    }
}
