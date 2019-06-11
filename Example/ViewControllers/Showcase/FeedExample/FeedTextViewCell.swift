//
//  FeedTextViewCell.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedTextViewCell: XCCollectionViewCell {
    private var titleLabel = UILabel().apply {
        $0.font = UIFont.systemFont(60)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.isMarkupEnabled = false
    }

    private var subtitleLabel = UILabel().apply {
        $0.font = UIFont.systemFont(20)
        $0.numberOfLines = 0
        $0.isMarkupEnabled = false
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // MARK: - View Lifecycle

    override func commonInit() {
        super.commonInit()
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
