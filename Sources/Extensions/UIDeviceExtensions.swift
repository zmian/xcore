//
// UIDeviceExtensions.swift
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

public extension UIDevice {
    public struct ScreenSize {
        public static var width: CGFloat     { return UIScreen.mainScreen().bounds.width }
        public static var height: CGFloat    { return UIScreen.mainScreen().bounds.height }
        public static var minLength: CGFloat { return min(width, height) }
        public static var maxLength: CGFloat { return max(width, height) }
    }

    public struct DeviceType {
        public static var iPhone4OrLess: Bool { return iPhone && ScreenSize.maxLength < 568 }
        public static var iPhone5: Bool       { return iPhone && ScreenSize.maxLength == 568 }
        public static var iPhone6: Bool       { return iPhone && ScreenSize.maxLength == 667 }
        public static var iPhone6Plus: Bool   { return iPhone && ScreenSize.maxLength == 736 }
        public static var Simulator: Bool     { return TARGET_IPHONE_SIMULATOR == 1 }
        public static var iPhone: Bool        { return UIDevice.currentDevice().userInterfaceIdiom == .Phone }
        public static var iPad: Bool          { return UIDevice.currentDevice().userInterfaceIdiom == .Pad }
    }

    public struct SystemVersion {
        public static let iOS8OrGreater = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_0)
        public static let iOS7OrLess    = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_0)

        @warn_unused_result
        public static func lessThanOrEqual(string: String) -> Bool {
            return  UIDevice.currentDevice().systemVersion.compare(string, options: .NumericSearch, range: nil, locale: nil) == .OrderedAscending
        }

        @warn_unused_result
        public static func greaterThanOrEqual(string: String) -> Bool {
            return !lessThanOrEqual(string)
        }

        @warn_unused_result
        public static func equal(string: String) -> Bool {
            return  UIDevice.currentDevice().systemVersion.compare(string, options: .NumericSearch, range: nil, locale: nil) == .OrderedSame
        }
    }
}

public extension UIDevice {

    public enum ModelType: CustomStringConvertible {
        case Unknown(String)
        case Simulator
        case iPodTouch
        case iPhone4, iPhone4s, iPhone5, iPhone5c, iPhone5s, iPhone6, iPhone6Plus, iPhone6s, iPhone6sPlus
        case iPad2, iPad3, iPad4, iPadAir, iPadAir2, iPadMini, iPadMini2, iPadMini3

        public var description: String {
            switch self {
                case Simulator:    return "Simulator"
                case iPodTouch:    return "iPod Touch"
                case iPhone4:      return "iPhone 4"
                case iPhone4s:     return "iPhone 4s"
                case iPhone5:      return "iPhone 5"
                case iPhone5c:     return "iPhone 5c"
                case iPhone5s:     return "iPhone 5s"
                case iPhone6:      return "iPhone 6"
                case iPhone6Plus:  return "iPhone 6 Plus"
                case iPhone6s:     return "iPhone 6s"
                case iPhone6sPlus: return "iPhone 6s Plus"
                case iPad2:        return "iPad 2"
                case iPad3:        return "iPad 3"
                case iPad4:        return "iPad 4"
                case iPadAir:      return "iPad Air"
                case iPadAir2:     return "iPad Air 2"
                case iPadMini:     return "iPad Mini"
                case iPadMini2:    return "iPad Mini 2"
                case iPadMini3:    return "iPad Mini 3"
                case Unknown(let identifier): return identifier
            }
        }

        static func modelNumber(identifier: String) -> ModelType {
            switch identifier {
                case "x86_64", "i386":
                    return .Simulator
                case "iPod5,1":
                    return .iPodTouch
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":
                    return .iPhone4
                case "iPhone4,1":
                    return .iPhone4s
                case "iPhone5,1", "iPhone5,2":
                    return .iPhone5
                case "iPhone5,3", "iPhone5,4":
                    return .iPhone5c
                case "iPhone6,1", "iPhone6,2":
                    return .iPhone5s
                case "iPhone7,2":
                    return .iPhone6
                case "iPhone7,1":
                    return .iPhone6Plus
                case "iPhone8,1":
                    return .iPhone6s
                case "iPhone8,2":
                    return .iPhone6sPlus
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                    return .iPad2
                case "iPad3,1", "iPad3,2", "iPad3,3":
                    return .iPad3
                case "iPad3,4", "iPad3,5", "iPad3,6":
                    return .iPad4
                case "iPad4,1", "iPad4,2", "iPad4,3":
                    return .iPadAir
                case "iPad5,1", "iPad5,3", "iPad5,4":
                    return .iPadAir2
                case "iPad2,5", "iPad2,6", "iPad2,7":
                    return .iPadMini
                case "iPad4,4", "iPad4,5", "iPad4,6":
                    return .iPadMini2
                case "iPad4,7", "iPad4,8", "iPad4,9":
                    return .iPadMini3
                default:
                    return .Unknown(identifier)
            }
        }
    }

    public var modelType: ModelType {
        return ModelType.modelNumber(modelNumber)
    }

    public var modelNumber: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror  = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children {
            if let value = child.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }

        return identifier
    }
}
