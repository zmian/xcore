//
//  FeedTextHeaderFooterViewCell.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedTextHeaderFooterViewCell: XCCollectionReusableView {
    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel
    ]).apply {
        $0.axis = .vertical
    }

    private let titleLabel = UILabel().apply {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .red
        $0.textAlignment = .center
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    override func commonInit() {
        super.commonInit()
        backgroundColor = .blue
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(.maximumPadding)
        }
    }
}
