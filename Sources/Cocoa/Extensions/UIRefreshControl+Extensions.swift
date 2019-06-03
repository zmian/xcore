//
// UIRefreshControl+Extensions.swift
//
// Copyright © 2015 Xcore
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

extension UIRefreshControl {
    private struct AssociatedKey {
        static var timeoutTimer = "timeoutTimer"
    }

    private var timeoutTimer: Timer? {
        get { return associatedObject(&AssociatedKey.timeoutTimer) }
        set { setAssociatedObject(&AssociatedKey.timeoutTimer, value: newValue) }
    }

    /// Tells the control that a refresh operation has ended.
    ///
    /// Call this method at the end of any refresh operation (whether it was initiated
    /// programmatically or by the user) to return the refresh control to its default state.
    /// If the refresh control is at least partially visible, calling this method also hides
    /// it. If animations are also enabled, the control is hidden using an animation.
    ///
    /// - Parameters:
    ///   - timeoutInterval: The delay before end refreshing.
    ///   - completion: A closure to execute after end refreshing.
    open func endRefreshing(after timeoutInterval: TimeInterval, completion: (() -> Void)? = nil) {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.schedule(delay: timeoutInterval) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            completion?()
        }
    }
}
