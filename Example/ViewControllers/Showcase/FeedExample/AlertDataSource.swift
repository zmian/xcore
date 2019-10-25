//
//  AlertDataSource.swift
//  Example
//
//  Created by Guillermo Waitzel on 24/10/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class AlertDataSource: XCCollectionViewDataSource {
    var alerts: [String] = [
        "Attend this place",
        "You have this to take care please take care of it!",
        "These is a long long message that has a lot of tasks lalsasd asdasd\nYou have this to take care please take care of it!\nLong Long Long"
    ]
    var isExtended: Bool = false {
        didSet {
            if isExtended != oldValue {
                let reloadSet = IndexSet(integersIn: globalSection...(globalSection + allSectionsCount - 1))
                collectionView?.performBatchUpdates({
                    collectionView?.reloadSections(reloadSet)
                })
            }
        }
    }

    private var allSectionsCount: Int {
        return 1 + 1 + alerts.count
    }

    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allSectionsCount
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 2:
                return isExtended ? 0 : 1
            case 1:
                return 1
            default:
                return isExtended ? 1 : 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let globalIndex = indexPath.with(globalSection)
        switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as HeaderCell
                cell.configure(didTapHide: { [weak self] in
                    self?.isExtended = false
                }, didTapClear: {
                    
                })
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as StackEffect
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as FeedTextViewCell
                cell.configure(
                    title: "Alert Number: \(globalIndex.section)",
                    subtitle: alerts.at(alertIndexFor(section: indexPath.section)) ?? ""
                )
                return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0,2:
                return
            default:
                guard isExtended else {
                    isExtended = true
                    return
                }
                print("Did select alert at index: \(alertIndexFor(section: indexPath.section))")
        }
    }

    private func alertIndexFor(section: Int) -> Int {
        switch section {
            case 1:
                return 0
            default:
                return section - 2
        }
    }
}

extension AlertDataSource: XCCollectionViewTileLayoutCustomizable {
    func isTileEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool {
        true
    }

    func isShadowEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool {
        switch section {
            case 0, 2:
                return false
            default:
                return true
        }
    }

    func parentIdentifier(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> String? {
        switch section {
            case 0, 2:
                return nil
            default:
                return "AlertStacked"
        }
    }

    func verticalBottomSpacing(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> CGFloat {
        switch section {
            case 0:
                return isExtended ? 0.0 : layout.verticalIntersectionSpacing
            case 1:
                return 0.0
            default:
                return layout.verticalIntersectionSpacing
        }
    }
}

extension AlertDataSource {
    final class HeaderCell: XCCollectionViewCell {
        lazy var hideButton = UIButton().apply {
            $0.text = "Show Less"
            $0.addAction(.touchUpInside) { [weak self] _ in
                self?.didTapHideAction?()
            }
        }
        lazy var clearButton = UIButton().apply {
            $0.text = "Clear"
            $0.addAction(.touchUpInside) { [weak self] _ in
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
            stackView.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.leading.trailing.equalToSuperview().inset(.maximumPadding)
                make.top.bottom.equalToSuperview().inset(.minimumPadding)
            }
        }

        func configure(didTapHide: @escaping () -> Void, didTapClear: @escaping () -> Void) {
            didTapHideAction = didTapHide
            didTapClearAction = didTapClear
        }
    }
}

extension AlertDataSource {
    final class StackEffect: XCCollectionViewCell {
        lazy var stackView = UIStackView(arrangedSubviews: [
            firstBottomView,
            secondBottomView
        ]).apply {
            $0.axis = .vertical
            $0.alignment = .center
            firstBottomView.snp.makeConstraints { make in
                make.height.equalTo(11)
                make.leading.trailing.equalToSuperview().inset(.defaultPadding)
            }
            secondBottomView.snp.makeConstraints { make in
                make.height.equalTo(11)
                make.leading.trailing.equalToSuperview().inset(1.5 * .defaultPadding)
            }
        }

        let firstBottomView = UIView().apply {
            $0.backgroundColor = UIColor.white.darker(0.1)
        }
        let secondBottomView = UIView().apply {
            $0.backgroundColor = UIColor.white.darker(0.2)
        }

        override var bounds: CGRect {
            didSet {
                stackView.layoutIfNeeded()
                roundLowerCorner(of: firstBottomView)
                roundLowerCorner(of: secondBottomView)
            }
        }

        func roundLowerCorner(of view: UIView) {
            let cornerRadius: CGFloat = 11
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

        override func commonInit() {
            contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            layer.zPosition = -1000
        }
    }
}
