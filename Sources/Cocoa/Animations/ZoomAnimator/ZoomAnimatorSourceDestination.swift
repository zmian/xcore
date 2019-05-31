//
// ZoomAnimatorSourceDestination.swift
//
// Copyright © 2017 Xcore
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

// MARK: ZoomAnimatorSource

public protocol ZoomAnimatorSource {
    func zoomAnimatorSourceView() -> UIView
    func zoomAnimatorSourceViewFrame(direction: AnimationDirection) -> CGRect
    func zoomAnimatorSourceStateChanged(state: AnimationState)
    func zoomAnimatorSourceAnimation(animations: @escaping () -> Void, completion: @escaping () -> Void)
    var zoomAnimatorSourceDuration: TimeInterval { get }
}

extension ZoomAnimatorSource {
    public var zoomAnimatorSourceDuration: TimeInterval {
        return 0.35
    }

    public func zoomAnimatorSourceAnimation(animations: @escaping () -> Void, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: zoomAnimatorSourceDuration, delay: 0, options: .curveEaseInOut, animations: animations) { _ in
            completion()
        }
    }
}

extension ZoomAnimatorSource where Self: UIViewController {
    public func zoomAnimatorSourceViewFrame(direction: AnimationDirection) -> CGRect {
        let sourceView = zoomAnimatorSourceView()
        return sourceView.convert(sourceView.bounds, to: view)
    }

    public func zoomAnimatorSourceStateChanged(state: AnimationState) {
        switch state {
            case .began:
                zoomAnimatorSourceView().alpha = 0
            case .cancelled, .ended:
                zoomAnimatorSourceView().alpha = 1
        }
    }
}

// MARK: ZoomAnimatorDestination

public protocol ZoomAnimatorDestination {
    func zoomAnimatorDestinationViewFrame(direction: AnimationDirection) -> CGRect
    func zoomAnimatorDestinationStateChanged(state: AnimationState)
    func zoomAnimatorDestinationAnimation(animations: @escaping () -> Void, completion: @escaping () -> Void)
    var zoomAnimatorDestinationDuration: TimeInterval { get }
}

extension ZoomAnimatorDestination {
    public var zoomAnimatorDestinationDuration: TimeInterval {
        return 0.35
    }

    public func zoomAnimatorDestinationAnimation(animations: @escaping () -> Void, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: zoomAnimatorDestinationDuration, delay: 0, options: .curveEaseInOut, animations: animations) { _ in
            completion()
        }
    }
}
