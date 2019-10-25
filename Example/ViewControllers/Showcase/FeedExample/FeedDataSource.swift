//
// FeedDataSource.swift
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

final class FeedDataSource: XCCollectionViewDataSource {
    static var isRandomEnabled = false
    let cellCount = Int.random(in: 1...2)
    var sectionIndex: Int
    var isVisible: Bool = true
    var isInverted: Bool = false

    lazy var names: [(String, String)] = {
        let textSize = Int.random(in: 1...3)

        guard cellCount > 0 else {
            return [(String, String)]()
        }

        var detailText = ""
        for _ in 0..<textSize {
            detailText.append("Lore ipsum alalas dasfasfasf\n")
        }
        return [("AA", "BB")]
    }()

    var isTileEnabled = true
    var cornerRadius: CGFloat = 11
    var isShadowEnabled = true

    init(collectionView: UICollectionView, sectionIndex: Int) {
        self.sectionIndex = sectionIndex
        super.init(collectionView: collectionView)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedTextViewCell
        cell.configure(title: "S: \(sectionIndex)", subtitle: "")
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let header = collectionView.dequeueReusableSupplementaryView(.header, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        header.configure(title: "S: \(sectionIndex)")
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let footer = collectionView.dequeueReusableSupplementaryView(.footer, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        footer.configure(title: "FOOTER!")
        return footer
    }
}

extension FeedDataSource: XCCollectionViewTileLayoutCustomizable {
    func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool {
        isTileEnabled
    }

    func isShadowEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool {
        true
    }

    func cornerRadius(in layout: XCCollectionViewTileLayout) -> CGFloat {
        cornerRadius
    }

    func parentIdentifier(in layout: XCCollectionViewTileLayout) -> String? {
        return "Stacked"
    }
}
