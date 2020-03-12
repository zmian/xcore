//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class XCScrollViewController: UIViewController {
    public let scrollView = UIScrollView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }

    private func setupContentView() {
        view.addSubview(scrollView)
        scrollView.anchor.edges.equalToSuperview()
        resolveContentSize()
    }

    private func resolveContentSize() {
        scrollView.resolve(axis: .vertical, fixedView: view)
    }
}
