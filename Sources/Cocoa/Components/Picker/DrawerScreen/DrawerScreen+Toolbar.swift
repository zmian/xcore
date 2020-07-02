//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension DrawerScreen {
    final class Toolbar: XCView {
        var height: CGFloat = AppConstants.uiControlsHeight {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }

        let dismissButton = UIButton(assetIdentifier: .closeIcon).apply {
            $0.accessibilityIdentifier = "dismissButton"
            $0.accessibilityLabel = "Dismiss Picker"
            $0.contentTintColor = .appTint
        }

        override var intrinsicContentSize: CGSize {
            .init(width: UIView.noIntrinsicMetric, height: height)
        }

        override func commonInit() {
            addBorder(edges: .bottom, color: .appSeparator, thickness: .onePixel)
            backgroundColor = .clear

            addSubview(dismissButton)
            dismissButton.anchor.make {
                $0.trailing.equalToSuperview().inset(CGFloat.defaultPadding)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
