//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class FeedColorViewCell: XCCollectionViewCell {
    var heightConstraint: Constraint?
    var colorView = UIView()

    func configure(height: CGFloat, color: UIColor) {
        contentView.backgroundColor = color
        heightConstraint?.update(offset: height)
    }

    override func commonInit() {
        super.commonInit()

        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(0).priority(.high).constraint
        }
    }
}
