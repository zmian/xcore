//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class XCView: UIView {
    // MARK: - Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Setup Methods

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() {}
}
