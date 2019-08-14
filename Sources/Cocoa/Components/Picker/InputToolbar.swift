//
// InputToolbar.swift
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

import Foundation

final public class InputToolbar: XCView {
    private let buttonSize = CGSize(width: 60, height: 30)

    public var title: StringRepresentable? {
        didSet {
            titleLabel.setText(title)
        }
    }

    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        cancelButton,
        titleContainer,
        otherButton,
        doneButton
    ]).apply {
        $0.spacing = .defaultPadding
        otherButton.isHidden = true
    }

    private lazy var cancelButton = UIButton(style: .plain).apply {
        $0.text = "Cancel"
        $0.accessibilityIdentifier = "inputCancelButton"
        $0.isHeightSetAutomatically = false
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.addAction(.touchUpInside) { [weak self] _ in
            self?.didTapCancel?()
        }
    }

    private lazy var doneButton = UIButton(style: .callout).apply {
        $0.text = "Done"
        $0.accessibilityIdentifier = "inputDoneButton"
        $0.isHeightSetAutomatically = false
        $0.contentEdgeInsets = .zero
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.addAction(.touchUpInside) { [weak self] _ in
            self?.didTapDone?()
        }
    }

    private lazy var otherButton = UIButton(style: .calloutSecondary).apply {
        $0.text = "Other"
        $0.accessibilityIdentifier = "inputOtherButton"
        $0.isHeightSetAutomatically = false
        $0.contentEdgeInsets = .zero
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.addAction(.touchUpInside) { [weak self] _ in
            self?.didTapOther?()
        }
    }

    private let titleLabel = UILabel().apply {
        $0.font = .app(style: .caption1)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }

    private let titleContainer = UIView().apply {
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    public override func commonInit() {
        backgroundColor = .white
        addSubview(buttonStackView)

        buttonStackView.anchor.make {
            let inset = UIEdgeInsets(horizontal: .defaultPadding, vertical: .minimumPadding)
            $0.edges.equalToSuperview().inset(inset)
        }

        titleContainer.addSubview(titleLabel)
        titleLabel.anchor.make {
            $0.centerX.equalTo(anchor.centerX)
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.vertically.equalToSuperview()
        }
    }

    // MARK: - UIAppearance Properties

    @objc public dynamic var cancelTitle: String? {
        get { return cancelButton.text }
        set { cancelButton.text = newValue }
    }

    @objc public dynamic var doneTitle: String? {
        get { return doneButton.text }
        set { doneButton.text = newValue }
    }

    @objc public dynamic var otherTitle: String? {
        get { return otherButton.text }
        set { otherButton.text = newValue }
    }

    @objc public dynamic var titleTextColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    // MARK: - API

    private var didTapDone: (() -> Void)?
    public func didTapDone(_ callback: @escaping () -> Void) {
        didTapDone = callback
    }

    private var didTapCancel: (() -> Void)?
    public func didTapCancel(_ callback: @escaping () -> Void) {
        didTapCancel = callback
    }

    private var didTapOther: (() -> Void)?
    public func didTapOther(_ callback: @escaping () -> Void) {
        didTapOther = callback
        otherButton.isHidden = false
    }
}
