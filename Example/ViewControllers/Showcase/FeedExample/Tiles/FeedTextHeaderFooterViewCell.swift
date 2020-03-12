//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

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
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10.0)
        }
    }
}
