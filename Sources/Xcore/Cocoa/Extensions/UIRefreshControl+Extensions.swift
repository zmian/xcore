//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - End refreshing with timeout

extension UIRefreshControl {
    private enum AssociatedKey {
        static var timeoutTimer = "timeoutTimer"
    }

    private var timeoutTimer: Timer? {
        get { associatedObject(&AssociatedKey.timeoutTimer) }
        set { setAssociatedObject(&AssociatedKey.timeoutTimer, value: newValue) }
    }

    /// Tells the control that a refresh operation has ended.
    ///
    /// Call this method at the end of any refresh operation (whether it was
    /// initiated programmatically or by the user) to return the refresh control to
    /// its default state. If the refresh control is at least partially visible,
    /// calling this method also hides it. If animations are also enabled, the
    /// control is hidden using an animation.
    ///
    /// - Parameters:
    ///   - timeoutInterval: The delay before end refreshing.
    ///   - completion: A closure to execute after end refreshing.
    open func endRefreshing(after timeoutInterval: TimeInterval, completion: (() -> Void)? = nil) {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.after(timeoutInterval) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            completion?()
        }
    }
}
