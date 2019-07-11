//
// CarouselViewTypes.swift
//
// Copyright © 2016 Xcore
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

public typealias CarouselViewCellType = UICollectionViewCell & CarouselViewCellRepresentable
public typealias CarouselAccessibilityItem = (label: String, value: String)

public protocol CarouselAccessibilitySupport {
    func accessibilityItem(index: Int) -> CarouselAccessibilityItem?
}

public protocol CarouselViewModelRepresentable: CarouselAccessibilitySupport {
    associatedtype Model

    func numberOfItems() -> Int
    func itemViewModel(index: Int) -> Model?
}

public protocol CarouselViewCellRepresentable: Reusable {
    associatedtype Model

    func configure(_ model: Model)

    func didSelectItem(_ callback: @escaping () -> Void)

    /// A convenience method to specify the cell width.
    /// The default value is width of the collection view.
    func preferredWidth(collectionView: UICollectionView) -> CGFloat
}

extension CarouselViewCellRepresentable {
    public func preferredWidth(collectionView: UICollectionView) -> CGFloat {
        return collectionView.frame.width
    }

    public func didSelectItem(_ callback: @escaping () -> Void) { }
}
