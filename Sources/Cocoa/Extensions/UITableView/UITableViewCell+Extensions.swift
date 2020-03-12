//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITableViewCell {
    private struct AssociatedKey {
        static var backgroundColors = "backgroundColors"
        static var highlightedAnimation = "highlightedAnimation"
    }

    /// A boolean property to provide visual feedback when the
    /// cell is highlighted. The default value is `.none`.
    open var highlightedAnimation: HighlightedAnimationOptions {
        get { associatedObject(&AssociatedKey.highlightedAnimation, default: .none) }
        set { setAssociatedObject(&AssociatedKey.highlightedAnimation, value: newValue) }
    }
}

// MARK: - Highlighted Background Color

extension UITableViewCell {
    /// The background color for the highlighted state.
    @objc open dynamic var highlightedBackgroundColor: UIColor? {
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
    @objc open var highlightedBackgroundColorView: UIView {
        self
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc open var highlightedAnimationView: UIView {
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

// MARK: - Swizzled Methods

extension UITableViewCell {
    func _setHighlighted(_ highlighted: Bool, animated: Bool) {
        highlightedAnimation.animate(highlightedAnimationView, isHighlighted: highlighted)

        guard let highlightedBackgroundColor = highlightedBackgroundColor else {
            return
        }

        // Make sure we always store unhighlighted background color so we can later restore it.
        if highlightedBackgroundColor != highlightedBackgroundColorView.backgroundColor {
            normalBackgroundColor = highlightedBackgroundColorView.backgroundColor
        }

        let newBackgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor

        UIView.animateFromCurrentState(withDuration: animated ? 0.15 : 0) {
            self.highlightedBackgroundColorView.backgroundColor = newBackgroundColor
        }
    }
}
