//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An object representing the device’s screen.
public final class Screen: ObservableObject, Sendable {
    /// Returns the screen object representing the device’s screen.
    static let main = Screen()

    /// The natural scale factor associated with the screen.
    ///
    /// This value reflects the scale factor needed to convert from the default
    /// logical coordinate space into the device coordinate space of this screen.
    /// The default logical coordinate space is measured using points. For Retina
    /// displays, the scale factor may be `3.0` or `2.0` and one point can
    /// represented by nine or four pixels, respectively. For standard-resolution
    /// displays, the scale factor is `1.0` and one point equals one pixel.
    public let scale = MainActor.performIsolated {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.scale
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenScale
        #elseif os(macOS)
        return NSScreen.main?.backingScaleFactor ?? 1.0
        #else
        return 1.0
        #endif
    }

    /// The bounding rectangle of the screen, measured in points.
    public var bounds: CGRect {
        MainActor.performIsolated {
            #if os(iOS) || os(tvOS)
            return UIScreen.main.bounds
            #elseif os(watchOS)
            return WKInterfaceDevice.current().screenBounds
            #elseif os(macOS)
            return NSScreen.main?.frame ?? .zero
            #endif
        }
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
    @MainActor
    public var brightness: CGFloat {
        get {
            #if os(iOS) || targetEnvironment(macCatalyst)
            return UIScreen.main.brightness
            #else
            return 1.0
            #endif
        }
        set {
            #if os(iOS) || targetEnvironment(macCatalyst)
            UIScreen.main.brightness = newValue
            #endif
        }
    }

    nonisolated(unsafe) private var cancellable: AnyCancellable?

    private init() {
        #if os(iOS)
        cancellable = NotificationCenter
            .default
            .publisher(for: UIDevice.orientationDidChangeNotification, object: nil)
            .receive(on: .main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        #endif
    }
}
