//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension DrawerScreen {
    final class Toolbar: XCView {
        let dismissButton = UIButton(assetIdentifier: .closeIcon).apply {
            $0.accessibilityIdentifier = "dismissButton"
        }

        override var intrinsicContentSize: CGSize {
            .init(width: UIView.noIntrinsicMetric, height: 44)
        }

        override func commonInit() {
            addBorder(edges: .bottom, color: .appSeparator)
            backgroundColor = .clear

            addSubview(dismissButton)
            dismissButton.anchor.make {
                $0.trailing.equalToSuperview().inset(CGFloat.defaultPadding)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
