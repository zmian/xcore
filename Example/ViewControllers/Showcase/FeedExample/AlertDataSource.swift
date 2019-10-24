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
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as FeedColorViewCell
                cell.configure(height: 30, color: .blue)
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

    func isShadowEnabled(in layout: XCCollectionViewTileLayout) -> Bool {
        false
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
            case 0, 1:
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
