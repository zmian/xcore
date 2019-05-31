//
//  FeedTextViewCell.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedTextViewCell: XCCollectionViewCell {
    private lazy var titleLabel = UILabel().apply {
        $0.font = UIFont.systemFont(20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private lazy var subtitleLabel = UILabel().apply {
        $0.font = UIFont.systemFont(16)
        $0.numberOfLines = 0
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel,
        subtitleLabel,
    ]).apply {
        $0.axis = .vertical
        $0.spacing = .maximumPadding
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // MARK: - View Lifecycle

    override func commonInit() {
        super.commonInit()
        contentView.backgroundColor = .white
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
