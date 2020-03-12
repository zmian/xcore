//
// SplitScreenViewController.swift
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class SplitScreenViewController: UIViewController {
    public let headerContainerView = UIView()
    public let bodyContainerView = UIView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViews()
        setupConstraints()
    }

    open func addViewController(toHeaderContainerView vc: UIViewController, enableConstraints: Bool = true, inset: UIEdgeInsets = 0) {
        addViewController(vc, containerView: headerContainerView, enableConstraints: enableConstraints, inset: inset)
    }

    open func addViewController(toBodyContainerView vc: UIViewController, enableConstraints: Bool = true, inset: UIEdgeInsets = 0) {
        addViewController(vc, containerView: bodyContainerView, enableConstraints: enableConstraints, inset: inset)
    }

    // MARK: - Setup Methods: Container Views

    private func setupContainerViews() {
        view.addSubview(headerContainerView)

        bodyContainerView.clipsToBounds = true
        view.addSubview(bodyContainerView)
    }

    private func setupConstraints() {
        let headerContainerViewAspectRatio: CGFloat = 16/9.1 // Set to 9.1 to ensure iPhone 5S landscape view doesn't have 1px gap below
        let priority = UILayoutPriority.defaultHigh

        // Setup constraints: headerContainerView
        headerContainerView.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.top.equalToSuperview()
        }
        // Set aspect-ratio priority to low this ensures that landscape view works as expected.
        NSLayoutConstraint(item: headerContainerView, attribute: .width, toItem: headerContainerView, attribute: .height, multiplier: headerContainerViewAspectRatio, priority: priority).activate()

        // Setup constraints: bodyContainerView
        bodyContainerView.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.bottom.equalToSuperview().priority(priority)
            $0.top.equalTo(headerContainerView.anchor.bottom)
        }
    }
}
