//
//  FeedColorViewCell.swift
//  Example
//
//  Created by Guillermo Waitzel on 06/06/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation
import SnapKit

final class FeedColorViewCell: XCCollectionViewCell {
    var heightConstraint: Constraint?
    var colorView = UIView()
    // MARK: - View Lifecycle

    func configure(height: CGFloat, color: UIColor) {
        contentView.backgroundColor = color
        heightConstraint?.update(offset: height)
    }

    override func commonInit() {
        super.commonInit()

        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(0).priority(.defaultHigh).constraint
        }
    }
}
