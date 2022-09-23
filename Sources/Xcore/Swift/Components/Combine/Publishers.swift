//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import UIKit
import Combine

extension Publishers {
    private static func notifications(for name: Notification.Name) -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: name)
    }

    /// Emits an event whenever keyboard visibility changes.
    public static var keyboardShown: AnyPublisher<Bool, Never> {
        let willShow = notifications(for: UIApplication.keyboardWillShowNotification)
            .map { _ in true }

        let willHide = notifications(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }

    /// Emits an event whenever keyboard visibility and frame changes.
    public static func keyboardCurrentHeight(safeAreaInsetsBottom: CGFloat = 0) -> AnyPublisher<CGFloat, Never> {
        let willShow = notifications(for: UIApplication.keyboardWillShowNotification)
            .merge(with:
                notifications(for: UIApplication.keyboardWillChangeFrameNotification)
            )
            .compactMap {
                $0.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map {
                $0.height - safeAreaInsetsBottom
            }
            .eraseToAnyPublisher()

        let willHide = notifications(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat.zero }
            .eraseToAnyPublisher()

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    /// Emits an event whenever protected data availability changes.
    public static var protectedDataAvailability: AnyPublisher<Bool, Never> {
        let available = notifications(for: UIApplication.protectedDataDidBecomeAvailableNotification)
            .map { _ in true }

        let unavailable = notifications(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
            .map { _ in false }

        return MergeMany(available, unavailable)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    /// Emits an event whenever window visibility changes.
    public static var windowVisibility: AnyPublisher<Void, Never> {
        MergeMany(
            notifications(for: UIWindow.didBecomeHiddenNotification),
            notifications(for: UIWindow.didBecomeVisibleNotification),
            notifications(for: UIApplication.didBecomeActiveNotification)
        )
        .eraseToVoidAnyPublisher()
    }
}
#endif
