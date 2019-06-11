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
    var textView = UILabel()
    // MARK: - View Lifecycle

    func configure(height: CGFloat, color: UIColor) {
        contentView.backgroundColor = color
        heightConstraint?.update(offset: height)
        textView.text = "This is Awesome!."
    }

    override func commonInit() {
        super.commonInit()

        contentView.addSubview(textView)
        textView.isMarkupEnabled = false
        textView.font = UIFont(name: "Helvetica", size: 40.0)
        textView.numberOfLines = 0
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            heightConstraint = make.height.equalTo(0).priority(.defaultHigh).constraint
        }
    }
}
