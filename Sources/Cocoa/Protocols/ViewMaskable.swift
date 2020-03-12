//
// ViewMaskable.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

public protocol ViewMaskable: class {
    static func add(to superview: UIView) -> Self
    func dismiss(_ completion: (() -> Void)?)
    var preferredNavigationBarTintColor: UIColor { get }
    var preferredStatusBarStyle: UIStatusBarStyle { get }
}

extension ViewMaskable {
    public var preferredNavigationBarTintColor: UIColor {
        .appTint
    }

    public var preferredStatusBarStyle: UIStatusBarStyle {
        preferredNavigationBarTintColor == .white ? .lightContent : .default
    }

    public func dismiss(after delayDuration: TimeInterval, _ completion: (() -> Void)? = nil) {
        delay(by: delayDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(completion)
        }
    }
}
