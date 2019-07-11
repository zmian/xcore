//
// XCCollectionViewTileLayout+Attributes.swift
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

extension XCCollectionViewTileLayout {
    final class Attributes: XCCollectionViewFlowLayout.Attributes {
        var corners: (corners: UIRectCorner, radius: CGFloat) = (.none, 0)
        var isAutosizeEnabled: Bool = false
        var offsetInSection: CGFloat = 0

        override func copy(with zone: NSZone? = nil) -> Any {
            guard let copy = super.copy(with: zone) as? Attributes else {
                return super.copy(with: zone)
            }
            copy.isAutosizeEnabled = isAutosizeEnabled
            copy.corners = corners
            copy.offsetInSection = offsetInSection
            return copy
        }
    }
}
