//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Namespace

public enum LaunchScreen {}

// MARK: - View

extension LaunchScreen {
    open class View: HUD {
        private let imageView = UIImageView(assetIdentifier: .launchScreenIcon)

        public override init() {
            super.init()
            windowLabel = "LaunchScreen Window"
            preferredStatusBarStyle = .lightContent
            add(imageView)
            imageView.anchor.make {
                $0.center.equalToSuperview()
            }
        }
    }
}

// MARK: - ViewController

extension LaunchScreen {
    open class ViewController: UIViewController, ObstructableView {
        private let launchView = View()

        open override func viewDidLoad() {
            super.viewDidLoad()
            launchView.show(animated: false)
        }

        open override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            launchView.hide()
        }
    }
}
