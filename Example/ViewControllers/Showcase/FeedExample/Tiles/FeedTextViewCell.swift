//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class FeedTextViewCell: XCCollectionViewCell {
    private var titleLabel = UILabel().apply {
        $0.font = .systemFont(size: 40)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.isMarkupEnabled = false
    }

    private var subtitleLabel = UILabel().apply {
        $0.font = .systemFont(size: 20)
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
        contentView.backgroundColor = Theme.current.backgroundColor
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(.defaultPadding)
            make.top.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(.defaultPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
