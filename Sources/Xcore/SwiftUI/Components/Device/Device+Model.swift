//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable switch_case_on_newline

import SwiftUI

extension Device {
    public indirect enum Model: Hashable, CustomStringConvertible {
        case unknown(String)
        case simulator(Model)

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
        case iPhoneXS, iPhoneXSMax
        case iPhoneXR
        case iPhone11, iPhone11Pro, iPhone11ProMax
        case iPhoneSE2
        case iPhone12, iPhone12Mini, iPhone12Pro, iPhone12ProMax

        // iPad
        case iPad_1
        case iPad_2
        case iPad_3
        case iPad_4
        case iPad_5
        case iPad_6
        case iPad_7
        case iPad_8
        case iPadMini_1
        case iPadMini_2
        case iPadMini_3
        case iPadMini_4
        case iPadMini_5
        case iPadAir_1
        case iPadAir_2
        case iPadAir_3
        case iPadAir_4
        case iPadPro_97Inch
        case iPadPro_10Inch
        case iPadPro_11Inch_1
        case iPadPro_11Inch_2
        case iPadPro_11Inch_3
        case iPadPro_12Inch_1
        case iPadPro_12Inch_2
        case iPadPro_12Inch_3
        case iPadPro_12Inch_4
        case iPadPro_12Inch_5

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
        case appleWatchSeries5_40mm
        case appleWatchSeries5_44mm
        case appleWatchSeries6_40mm
        case appleWatchSeries6_44mm
        case appleWatchSE_40mm
        case appleWatchSE_44mm

        // Apple TV
        case appleTV1
        case appleTV2
        case appleTV3
        case appleTVHD
        case appleTV4K
        case appleTV4K2

        // iPod
        case iPodTouch1
        case iPodTouch2
        case iPodTouch3
        case iPodTouch4
        case iPodTouch5
        case iPodTouch6
        case iPodTouch7

        // HomePod
        case homePod

        fileprivate init(identifier: String) {
            var value: Self {
                switch identifier {
                    // MARK: - iPhone

                    case "iPhone1,1": return .iPhone2G
                    case "iPhone1,2": return .iPhone3G
                    case "iPhone2,1": return .iPhone3Gs
                    case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .iPhone4
                    case "iPhone4,1": return .iPhone4s
                    case "iPhone5,1", "iPhone5,2": return .iPhone5
                    case "iPhone5,3", "iPhone5,4": return .iPhone5c
                    case "iPhone6,1", "iPhone6,2": return .iPhone5s
                    case "iPhone8,4": return .iPhoneSE
                    case "iPhone7,2": return .iPhone6
                    case "iPhone7,1": return .iPhone6Plus
                    case "iPhone8,1": return .iPhone6s
                    case "iPhone8,2": return .iPhone6sPlus
                    case "iPhone9,1", "iPhone9,3": return .iPhone7
                    case "iPhone9,2", "iPhone9,4": return .iPhone7Plus
                    case "iPhone10,1", "iPhone10,4": return .iPhone8
                    case "iPhone10,2", "iPhone10,5": return .iPhone8Plus
                    case "iPhone10,3", "iPhone10,6": return .iPhoneX
                    case "iPhone11,2": return .iPhoneXS
                    case "iPhone11,4", "iPhone11,6": return .iPhoneXSMax
                    case "iPhone11,8": return .iPhoneXR
                    case "iPhone12,1": return .iPhone11
                    case "iPhone12,3": return .iPhone11Pro
                    case "iPhone12,5": return .iPhone11ProMax
                    case "iPhone12,8": return .iPhoneSE2
                    case "iPhone13,2": return .iPhone12
                    case "iPhone13,1": return .iPhone12Mini
                    case "iPhone13,3": return .iPhone12Pro
                    case "iPhone13,4": return .iPhone12ProMax

                    // MARK: - iPad

                    case "iPad1,1", "iPad1,2": return .iPad_1
                    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .iPad_2
                    case "iPad3,1", "iPad3,2", "iPad3,3": return .iPad_3
                    case "iPad3,4", "iPad3,5", "iPad3,6": return .iPad_4
                    case "iPad6,11", "iPad6,12": return .iPad_5
                    case "iPad7,5", "iPad7,6": return .iPad_6
                    case "iPad7,11", "iPad7,12": return .iPad_7
                    case "iPad11,6", "iPad11,7": return .iPad_8
                    case "iPad4,1", "iPad4,2", "iPad4,3": return .iPadAir_1
                    case "iPad5,3", "iPad5,4": return .iPadAir_2
                    case "iPad11,3", "iPad11,4": return .iPadAir_3
                    case "iPad13,1", "iPad13,2": return .iPadAir_4
                    case "iPad2,5", "iPad2,6", "iPad2,7": return .iPadMini_1
                    case "iPad4,4", "iPad4,5", "iPad4,6": return .iPadMini_2
                    case "iPad4,7", "iPad4,8", "iPad4,9": return .iPadMini_3
                    case "iPad5,1", "iPad5,2": return .iPadMini_4
                    case "iPad11,1", "iPad11,2": return .iPadMini_5
                    case "iPad6,3", "iPad6,4": return .iPadPro_97Inch
                    case "iPad7,3", "iPad7,4": return .iPadPro_10Inch
                    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return .iPadPro_11Inch_1
                    case "iPad8,9", "iPad8,10": return .iPadPro_11Inch_2
                    case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return .iPadPro_11Inch_3
                    case "iPad6,7", "iPad6,8": return .iPadPro_12Inch_1
                    case "iPad7,1", "iPad7,2": return .iPadPro_12Inch_2
                    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return .iPadPro_12Inch_3
                    case "iPad8,11", "iPad8,12": return .iPadPro_12Inch_4
                    case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return .iPadPro_12Inch_5

                    // MARK: - Apple Watch

                    case "Watch1,1": return .appleWatchSeries0_38mm
                    case "Watch1,2": return .appleWatchSeries0_42mm
                    case "Watch2,6": return .appleWatchSeries1_38mm
                    case "Watch2,7": return .appleWatchSeries1_42mm
                    case "Watch2,3": return .appleWatchSeries2_38mm
                    case "Watch2,4": return .appleWatchSeries2_42mm
                    case "Watch3,1", "Watch3,3": return .appleWatchSeries3_38mm
                    case "Watch3,2", "Watch3,4": return .appleWatchSeries3_42mm
                    case "Watch4,1", "Watch4,3": return .appleWatchSeries4_40mm
                    case "Watch4,2", "Watch4,4": return .appleWatchSeries4_44mm
                    case "Watch5,1", "Watch5,3": return .appleWatchSeries5_40mm
                    case "Watch5,2", "Watch5,4": return .appleWatchSeries5_44mm
                    case "Watch6,1", "Watch6,3": return .appleWatchSeries6_40mm
                    case "Watch6,2", "Watch6,4": return .appleWatchSeries6_44mm
                    case "Watch5,9", "Watch5,11": return .appleWatchSE_40mm
                    case "Watch5,10", "Watch5,12": return .appleWatchSE_44mm

                    // MARK: - Apple TV

                    case "AppleTV1,1": return .appleTV1
                    case "AppleTV2,1": return .appleTV2
                    case "AppleTV3,1", "AppleTV3,2": return .appleTV3
                    case "AppleTV5,3": return .appleTVHD
                    case "AppleTV6,2": return .appleTV4K
                    case "AppleTV11,1": return .appleTV4K2

                    // MARK: - iPod

                    case "iPod1,1": return .iPodTouch1
                    case "iPod2,1": return .iPodTouch2
                    case "iPod3,1": return .iPodTouch3
                    case "iPod4,1": return .iPodTouch4
                    case "iPod5,1": return .iPodTouch5
                    case "iPod7,1": return .iPodTouch6

                    // MARK: - HomePod

                    case "AudioAccessory1,1": return .homePod

                    default: return .unknown(identifier)
                }
            }

            #if targetEnvironment(simulator)
            self = .simulator(value)
            #else
            self = value
            #endif
        }

        public var description: String {
            switch self {
                case let .simulator(model): return "Simulator (\(model))"

                case .iPhone2G: return "iPhone 2G"
                case .iPhone3G: return "iPhone 3G"
                case .iPhone3Gs: return "iPhone 3Gs"
                case .iPhone4: return "iPhone 4"
                case .iPhone4s: return "iPhone 4s"
                case .iPhone5: return "iPhone 5"
                case .iPhone5c: return "iPhone 5c"
                case .iPhone5s: return "iPhone 5s"
                case .iPhoneSE: return "iPhone SE"
                case .iPhone6: return "iPhone 6"
                case .iPhone6Plus: return "iPhone 6 Plus"
                case .iPhone6s: return "iPhone 6s"
                case .iPhone6sPlus: return "iPhone 6s Plus"
                case .iPhone7: return "iPhone 7"
                case .iPhone7Plus: return "iPhone 7 Plus"
                case .iPhone8: return "iPhone 8"
                case .iPhone8Plus: return "iPhone 8 Plus"
                case .iPhoneX: return "iPhone X"
                case .iPhoneXS: return "iPhone Xs"
                case .iPhoneXSMax: return "iPhone Xs Max"
                case .iPhoneXR: return "iPhone Xʀ"
                case .iPhone11: return "iPhone 11"
                case .iPhone11Pro: return "iPhone 11 Pro"
                case .iPhone11ProMax: return "iPhone 11 Pro Max"
                case .iPhoneSE2: return "iPhone SE (2nd generation)"
                case .iPhone12: return "iPhone 12"
                case .iPhone12Mini: return "iPhone 12 mini"
                case .iPhone12Pro: return "iPhone 12 Pro"
                case .iPhone12ProMax: return "iPhone 12 Pro Max"

                case .iPad_1: return "iPad (1st generation)"
                case .iPad_2: return "iPad (2nd generation)"
                case .iPad_3: return "iPad (3rd generation)"
                case .iPad_4: return "iPad (4th generation)"
                case .iPad_5: return "iPad (5th generation)"
                case .iPad_6: return "iPad (6th generation)"
                case .iPad_7: return "iPad (7th generation)"
                case .iPad_8: return "iPad (8th generation)"
                case .iPadAir_1: return "iPad Air (1st generation)"
                case .iPadAir_2: return "iPad Air (2nd generation)"
                case .iPadAir_3: return "iPad Air (3rd generation)"
                case .iPadAir_4: return "iPad Air (4th generation)"
                case .iPadMini_1: return "iPad Mini (1st generation)"
                case .iPadMini_2: return "iPad Mini (2nd generation)"
                case .iPadMini_3: return "iPad Mini (3rd generation)"
                case .iPadMini_4: return "iPad Mini (4th generation)"
                case .iPadMini_5: return "iPad Mini (5th generation)"
                case .iPadPro_97Inch: return "iPad Pro (9.7-inch)"
                case .iPadPro_10Inch: return "iPad Pro (10.5-inch)"
                case .iPadPro_11Inch_1: return "iPad Pro (11-inch)"
                case .iPadPro_11Inch_2: return "iPad Pro (11-inch) (2nd generation)"
                case .iPadPro_11Inch_3: return "iPad Pro (11-inch) (3rd generation)"
                case .iPadPro_12Inch_1: return "iPad Pro (12.9-inch)"
                case .iPadPro_12Inch_2: return "iPad Pro (12.9-inch) (2nd generation)"
                case .iPadPro_12Inch_3: return "iPad Pro (12.9-inch) (3rd generation)"
                case .iPadPro_12Inch_4: return "iPad Pro (12.9-inch) (4th generation)"
                case .iPadPro_12Inch_5: return "iPad Pro (12.9-inch) (5th generation)"

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
                case .appleWatchSeries5_40mm: return "Apple Watch Series 5 40mm"
                case .appleWatchSeries5_44mm: return "Apple Watch Series 5 44mm"
                case .appleWatchSeries6_40mm: return "Apple Watch Series 6 40mm"
                case .appleWatchSeries6_44mm: return "Apple Watch Series 6 44mm"
                case .appleWatchSE_40mm: return "Apple Watch SE 40mm"
                case .appleWatchSE_44mm: return "Apple Watch SE 44mm"

                case .appleTV1: return "Apple TV 1"
                case .appleTV2: return "Apple TV 2"
                case .appleTV3: return "Apple TV 3"
                case .appleTVHD: return "Apple TV HD"
                case .appleTV4K: return "Apple TV 4K"
                case .appleTV4K2: return "Apple TV 4K (2nd generation)"

                case .iPodTouch1: return "iPod touch (1st generation)"
                case .iPodTouch2: return "iPod touch (2nd generation)"
                case .iPodTouch3: return "iPod touch (3rd generation)"
                case .iPodTouch4: return "iPod touch (4th generation)"
                case .iPodTouch5: return "iPod touch (5th generation)"
                case .iPodTouch6: return "iPod touch (6th generation)"
                case .iPodTouch7: return "iPod touch (7th generation)"

                case .homePod: return "HomePod"

                case let .unknown(identifier): return identifier
            }
        }
    }
}

// MARK: - Model

extension Device {
    /// A strongly typed model type of the current device.
    ///
    /// ```swift
    /// // Strongly typed model type
    /// Device.current.model // e.g., Model.iPhone13Pro
    ///
    /// // User-friendly device name
    /// print(Device.current.model.name) // iPhone 13 Pro
    ///
    /// // Compile-time safe conditional check
    /// if Device.current.model == .iPhone13Pro {
    ///     ...
    /// }
    /// ```
    public var model: Model {
        .init(identifier: Model.internalIdentifier)
    }
}

// MARK: - Instance Properties

extension Device.Model {
    /// The name of the device model (e.g., "iPhone 12 Pro").
    ///
    /// The value of this property is an arbitrary alphanumeric string that is
    /// associated with the device as an identifier. For example, you can find the
    /// name of an iOS device in the `General > About` settings.
    public var name: String {
        #if os(iOS) || os(tvOS)
        return UIDevice.current.name
        #elseif os(watchOS)
        return WKInterfaceDevice.current().name
        #elseif os(macOS)
        return ProcessInfo.shared.hostName
        #endif
    }

    /// The family name of the device model (e.g., "iPhone" or "iPod touch").
    public var family: String {
        #if os(iOS) || os(tvOS)
        return UIDevice.current.model
        #elseif os(watchOS)
        return WKInterfaceDevice.current().model
        #elseif os(macOS)
        #warning("TODO: Implement")
        return ""
        #endif
    }

    /// The model identifier of the device (e.g., "iPhone9,2").
    public var identifier: String {
        let id = Self.internalIdentifier

        #if targetEnvironment(simulator)
        return "Simulator (\(id))"
        #else
        return id
        #endif
    }

    /// The model identifier of the current device (e.g., "iPhone9,2").
    fileprivate static var internalIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

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
