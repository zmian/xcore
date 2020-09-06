//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - ZoomAnimatorSource

public protocol ZoomAnimatorSource {
    func zoomAnimatorSourceView() -> UIView
    func zoomAnimatorSourceViewFrame(direction: AnimationDirection) -> CGRect
    func zoomAnimatorSourceStateChanged(state: AnimationState)
    func zoomAnimatorSourceAnimation(animations: @escaping () -> Void, completion: @escaping () -> Void)
    var zoomAnimatorSourceDuration: TimeInterval { get }
}

extension ZoomAnimatorSource {
    public var zoomAnimatorSourceDuration: TimeInterval {
        0.35
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

// MARK: - ZoomAnimatorDestination

public protocol ZoomAnimatorDestination {
    func zoomAnimatorDestinationViewFrame(direction: AnimationDirection) -> CGRect
    func zoomAnimatorDestinationStateChanged(state: AnimationState)
    func zoomAnimatorDestinationAnimation(animations: @escaping () -> Void, completion: @escaping () -> Void)
    var zoomAnimatorDestinationDuration: TimeInterval { get }
}

extension ZoomAnimatorDestination {
    public var zoomAnimatorDestinationDuration: TimeInterval {
        0.35
    }

    public func zoomAnimatorDestinationAnimation(animations: @escaping () -> Void, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: zoomAnimatorDestinationDuration, delay: 0, options: .curveEaseInOut, animations: animations) { _ in
            completion()
        }
    }
}
