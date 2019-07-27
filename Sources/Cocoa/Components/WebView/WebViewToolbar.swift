//
// WebViewToolbar.swift
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
