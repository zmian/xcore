//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - HeaderCell

extension StackingDataSource {
    final class HeaderCell: XCCollectionViewCell {
        lazy var hideButton = UIButton(configuration: .plain).apply {
            $0.contentHorizontalAlignment = .leading
            $0.action { [weak self] _ in
                self?.didTapHideAction?()
            }
        }

        lazy var clearButton = UIButton(configuration: .plain).apply {
            $0.contentHorizontalAlignment = .trailing
            $0.action { [weak self] _ in
                self?.didTapClearAction?()
            }
        }

        private var didTapHideAction: (() -> Void)?
        private var didTapClearAction: (() -> Void)?

        private lazy var stackView = UIStackView(arrangedSubviews: [
            hideButton,
            clearButton
        ]).apply {
            $0.distribution = .equalSpacing
        }

        override func commonInit() {
            contentView.addSubview(stackView)
            stackView.anchor.make { make in
                make.height.equalTo(CGFloat(30))
                make.horizontally.equalToSuperview().inset(CGFloat.defaultPadding)
                make.vertically.equalToSuperview()
            }
            layer.zPosition = -1000
        }

        func configure(didTapHide: @escaping () -> Void, didTapClear: @escaping () -> Void) {
            if UIAccessibility.isVoiceOverRunning {
                UIAccessibility.post(notification: .screenChanged, argument: hideButton)
            }
            didTapHideAction = didTapHide
            didTapClearAction = didTapClear
        }
    }
}

// MARK: - Stacking Effect

extension StackingDataSource {
    final class StackEffect: XCCollectionViewCell {
        private lazy var stackView = UIStackView(arrangedSubviews: [
            firstBottomView,
            secondBottomView
        ]).apply {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = -2
            firstBottomView.anchor.make { make in
                make.height.equalTo(AppConstants.tileCornerRadius)
                make.horizontally.equalToSuperview().inset(CGFloat.minimumPadding)
            }
            secondBottomView.anchor.make { make in
                make.height.equalTo(AppConstants.tileCornerRadius)
                make.horizontally.equalToSuperview().inset(.minimumPadding * 1.8)
            }
            secondBottomView.layer.zPosition = firstBottomView.layer.zPosition - 1
        }

        private let firstBottomView = UIView().apply {
            $0.backgroundColor = UIColor.white.crossFade(to: UIColor(hex: "E6ECF3"), delta: 0.5).darker(0.15)
        }

        private let secondBottomView = UIView().apply {
            $0.backgroundColor = UIColor.white.crossFade(to: UIColor(hex: "E6ECF3"), delta: 0.8).darker(0.08)
        }

        override var bounds: CGRect {
            didSet {
                stackView.layoutIfNeeded()
                roundLowerCorner(of: firstBottomView)
                roundLowerCorner(of: secondBottomView)
            }
        }

        override func commonInit() {
            contentView.addSubview(stackView)
            contentView.clipsToBounds = true
            stackView.anchor.make { make in
                make.top.equalToSuperview().inset(CGFloat(-1))
                make.horizontally.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            layer.zPosition = -1000
        }

        private func roundLowerCorner(of view: UIView) {
            let cornerRadius: CGFloat = AppConstants.tileCornerRadius
            let path = CGMutablePath()
            path.move(to: CGPoint.zero)
            path.addRelativeArc(
                center: CGPoint(x: view.frame.width - cornerRadius, y: 0.0),
                radius: cornerRadius,
                startAngle: 0,
                delta: .pi2
            )
            path.addRelativeArc(
                center: CGPoint(x: cornerRadius, y: 0.0),
                radius: cornerRadius,
                startAngle: .pi2,
                delta: .pi2
            )
            view.layer.masksToBounds = true
            view.layer.mask = CAShapeLayer().apply {
                $0.path = path
            }
        }

        func configure(isTwoOrMore: Bool) {
            secondBottomView.isHidden = !isTwoOrMore
        }
    }
}
