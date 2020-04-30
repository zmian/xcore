//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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

    private lazy var cancelButton = UIButton(configuration: .plain).apply {
        $0.text = "Cancel"
        $0.textColor = Theme.current.buttonBackgroundColorSecondary
        $0.accessibilityIdentifier = "inputCancelButton"
        $0.isHeightSetAutomatically = false
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.action { [weak self] _ in
            self?.didTapCancel?()
        }
    }

    private lazy var doneButton = UIButton(configuration: .callout).apply {
        $0.text = "Done"
        $0.textColor = Theme.current.buttonTextColor
        $0.accessibilityIdentifier = "inputDoneButton"
        $0.isHeightSetAutomatically = false
        $0.contentEdgeInsets = .zero
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.action { [weak self] _ in
            self?.didTapDone?()
        }
    }

    private lazy var otherButton = UIButton(configuration: .calloutSecondary).apply {
        $0.text = "Other"
        $0.accessibilityIdentifier = "inputOtherButton"
        $0.isHeightSetAutomatically = false
        $0.contentEdgeInsets = .zero
        $0.anchor.make {
            $0.size.equalTo(buttonSize)
        }
        $0.action { [weak self] _ in
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
        get { cancelButton.text }
        set { cancelButton.text = newValue }
    }

    @objc public dynamic var doneTitle: String? {
        get { doneButton.text }
        set { doneButton.text = newValue }
    }

    @objc public dynamic var otherTitle: String? {
        get { otherButton.text }
        set { otherButton.text = newValue }
    }

    @objc public dynamic var titleTextColor: UIColor {
        get { titleLabel.textColor }
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
