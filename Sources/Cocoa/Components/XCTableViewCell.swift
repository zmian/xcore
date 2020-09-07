//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class XCTableViewCell: UITableViewCell {
    // MARK: - Init Methods

    public convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
    }

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        internalCommonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalCommonInit()
    }

    // MARK: - Setup Methods

    open override func setSelected(_ selected: Bool, animated: Bool) { }
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        _setHighlighted(highlighted, animated: animated)
    }

    private func internalCommonInit() {
        backgroundColor = .clear
        commonInit()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() { }
}
