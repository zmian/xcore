//
// WebViewToolbar.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension WebViewToolbar {
    enum ButtonType {
        case back
        case forward
    }
}

final class WebViewToolbar: XCToolbar {
    static let height: CGFloat = 44

    private let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace).apply {
        $0.width = 20
    }

    private(set) lazy var backButton = UIBarButtonItem(assetIdentifier: .navigationBackArrow).apply {
        $0.accessibilityIdentifier = "webViewToolbar backButton"
        $0.addAction { [weak self] _ in
            self?.didTapButton?(.back)
        }
    }

    private(set) lazy var forwardButton = UIBarButtonItem(assetIdentifier: .navigationForwardArrow).apply {
        $0.accessibilityIdentifier = "webViewToolbar forwardButton"
        $0.addAction { [weak self] _ in
            self?.didTapButton?(.forward)
        }
    }

    override func commonInit() {
        addBorder(edges: .top, color: .appSeparator, thickness: .onePixel)
        isTransparent = true
        backgroundColor = .white
        items = [backButton, fixedSpace, forwardButton]
    }

    func updateHeight(isTabBarHidden: Bool) {
        if isTabBarHidden {
            preferredHeight = WebViewToolbar.height + AppConstants.homeIndicatorHeightIfPresent
        } else {
            preferredHeight = WebViewToolbar.height
        }
    }

    private var didTapButton: ((_ type: ButtonType) -> Void)?
    func didTapButton(_ callback: @escaping (_ type: ButtonType) -> Void) {
        didTapButton = callback
    }
}
