//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Namespace

public enum IdleTimer { }

// MARK: - API

extension IdleTimer {
    private static let windowContainer = WindowContainer()

    /// Updates existing or creates a new timeout gesture for given `window` object.
    ///
    /// You can observe the timeout event using
    /// `UIApplication.didTimeOutUserInteractionNotification`.
    public static func setUserInteractionTimeout(duration: TimeInterval? = nil, for window: UIWindow?) {
        guard let window = window else {
            return
        }

        windowContainer.add(window)

        if let duration = duration {
            windowContainer.timeoutDuration = duration
        }
    }
}
