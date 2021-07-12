//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Highlighted Animation

extension UITableViewCell {
    private enum AssociatedKey {
        static var backgroundColors = "backgroundColors"
        static var highlightedAnimation = "highlightedAnimation"
    }

    /// A boolean property to provide visual feedback when the cell is highlighted.
    /// The default value is `.none`.
    var highlightedAnimation: HighlightedAnimationOptions {
        get { associatedObject(&AssociatedKey.highlightedAnimation, default: .none) }
        set { setAssociatedObject(&AssociatedKey.highlightedAnimation, value: newValue) }
    }
}

// MARK: - Highlighted Background Color

extension UITableViewCell {
    /// The background color for the highlighted state.
    @objc public dynamic var highlightedBackgroundColor: UIColor? {
        get { backgroundColor(for: .highlighted) }
        set { setBackgroundColor(newValue, for: .highlighted) }
    }

    /// The background color for the normal state.
    private var normalBackgroundColor: UIColor? {
        get { backgroundColor(for: .normal) }
        set { setBackgroundColor(newValue, for: .normal) }
    }

    /// The view to which the `highlightedBackgroundColor` is applied.
    /// The default value is `self`.
    @objc var highlightedBackgroundColorView: UIView {
        self
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc var highlightedAnimationView: UIView {
        contentView
    }
}

// MARK: - Background Color Storage

extension UITableViewCell {
    private typealias State = UInt

    private var backgroundColors: [State: UIColor] {
        get { associatedObject(&AssociatedKey.backgroundColors, default: [:]) }
        set { setAssociatedObject(&AssociatedKey.backgroundColors, value: newValue) }
    }

    private func backgroundColor(for state: UIControl.State) -> UIColor? {
        backgroundColors[state.rawValue]
    }

    private func setBackgroundColor(_ backgroundColor: UIColor?, for state: UIControl.State) {
        backgroundColors[state.rawValue] = backgroundColor
    }
}

// MARK: - Highlighted Background Color

extension UITableViewCell {
    @objc
    func swizzled_setHighlighted(_ highlighted: Bool, animated: Bool) {
        highlightedAnimation.animate(highlightedAnimationView, isHighlighted: highlighted)

        guard let highlightedBackgroundColor = highlightedBackgroundColor else {
            return
        }

        // Make sure we always store unhighlighted background color so we can later restore it.
        if highlightedBackgroundColor != highlightedBackgroundColorView.backgroundColor {
            normalBackgroundColor = highlightedBackgroundColorView.backgroundColor
        }

        let newBackgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor

        UIView.animateFromCurrentState(duration: animated ? 0.15 : 0) {
            self.highlightedBackgroundColorView.backgroundColor = newBackgroundColor
        }
    }
}

// MARK: - Swizzle

extension UITableViewCell {
    static func runOnceSwapSelectors() {
        swizzle(
            UITableViewCell.self,
            originalSelector: #selector(UITableViewCell.setHighlighted(_:animated:)),
            swizzledSelector: #selector(UITableViewCell.swizzled_setHighlighted(_:animated:))
        )
    }
}
