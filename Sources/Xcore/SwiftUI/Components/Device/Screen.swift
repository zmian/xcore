//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An object representing the device’s screen.
@dynamicMemberLookup
public final class Screen: ObservableObject {
    /// Returns the screen object representing the device’s screen.
    static let main = Screen()

    /// The bounding rectangle of the screen, measured in points.
    public var bounds: CGRect {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.bounds
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenBounds
        #elseif os(macOS)
        return NSScreen.main?.frame ?? .zero
        #endif
    }

    /// The natural scale factor associated with the screen.
    public var scale: CGFloat {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.scale
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenScale
        #elseif os(macOS)
        return NSScreen.main?.backingScaleFactor ?? 1.0
        #endif
    }

    /// The size of the screen, measured in points.
    public var size: CGSize {
        bounds.size
    }

    /// The reference size associated with the screen.
    public var referenceSize: ReferenceSize {
        .init(screen: self)
    }

    /// The brightness level of the screen.
    ///
    /// This property is only supported on the main screen. The value of this
    /// property should be a number between `0.0` and `1.0`, inclusive.
    ///
    /// Brightness changes made by an app remain in effect until the device is
    /// locked, regardless of whether the app is closed. The system brightness
    /// (which the user can set in Settings or Control Center) is restored the next
    /// time the display is turned on.
    public var brightness: CGFloat {
        get {
            #if os(iOS) || targetEnvironment(macCatalyst)
            return UIScreen.main.brightness
            #else
            return 1
            #endif
        }
        set {
            #if os(iOS) || targetEnvironment(macCatalyst)
            UIScreen.main.brightness = newValue
            #endif
        }
    }

    public static subscript<T>(dynamicMember keyPath: KeyPath<Screen, T>) -> T {
        main[keyPath: keyPath]
    }

    private var cancellable: AnyCancellable?

    private init() {
        #if os(iOS)
        cancellable = NotificationCenter
            .default
            .publisher(for: UIDevice.orientationDidChangeNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        #endif
    }
}
