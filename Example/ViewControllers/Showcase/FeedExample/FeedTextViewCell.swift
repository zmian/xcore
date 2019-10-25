//
// FeedTextViewCell.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
        contentView.backgroundColor = .white
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
