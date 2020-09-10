//
// Xcore
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

final class WebViewToolbar: XCView {
    static var height: CGFloat {
        44 + AppConstants.homeIndicatorHeightIfPresent
    }

    private let backgroundView = BlurView().apply {
        $0.isUserInteractionEnabled = false
    }

    private lazy var toolbar = XCToolbar().apply {
        $0.isTransparent = true
        $0.backgroundColor = .clear
        $0.items = [backButton, fixedSpace, forwardButton]
    }

    private let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace).apply {
        $0.width = 24
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
        backgroundView.addBorder(edges: .top, color: .appSeparator, thickness: .onePixel)
        addSubview(backgroundView)
        backgroundColor = Theme.current.backgroundColor
        backgroundView.anchor.edges.equalToSuperview()
        addSubview(toolbar)
          toolbar.anchor.horizontally.equalToSuperview()
          toolbar.anchor.top.equalToSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = Self.height
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = Self.height
        return size
    }

    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: Self.height)
    }

    private var didTapButton: ((_ type: ButtonType) -> Void)?
    func didTapButton(_ callback: @escaping (_ type: ButtonType) -> Void) {
        didTapButton = callback
    }
}
