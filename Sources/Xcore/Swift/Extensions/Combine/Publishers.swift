//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import UIKit
import Combine

extension Publishers {
    /// Emits an event whenever keyboard visibility changes.
    public static var keyboardShown: AnyPublisher<Bool, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { _ in true }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }

        return Publishers.MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    /// Emits an event whenever protected data availability changes.
    public static var protectedDataAvailability: AnyPublisher<Bool, Never> {
        let available = NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
            .map { _ in true }

        let unavailable = NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
            .map { _ in false }

        return Publishers.MergeMany(available, unavailable)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    /// Emits an event whenever window visibility changes.
    public static var windowVisibility: AnyPublisher<Void, Never> {
        Publishers.MergeMany(
            NotificationCenter.default.publisher(for: UIWindow.didBecomeHiddenNotification),
            NotificationCenter.default.publisher(for: UIWindow.didBecomeVisibleNotification),
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        )
        .eraseToVoidAnyPublisher()
    }
}
#endif
