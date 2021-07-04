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
    public static let main = Screen()

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

    /// The width and height of the screen.
    public var size: CGSize {
        bounds.size
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

// MARK: - Environment Support

extension EnvironmentValues {
    private struct ScreenKey: EnvironmentKey {
        static var defaultValue: Screen = .main
    }

    /// An object representing the device’s screen.
    public var screen: Screen {
        get { self[ScreenKey.self] }
        set { self[ScreenKey.self] = newValue }
    }
}
