//
// InternalExtensions.swift
//
// Copyright © 2016 Zeeshan Mian
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

// MARK: UIView Utilities Extension

extension UIView {
    /// Get a child view by class name.
    ///
    /// - parameter className: The class name of the child view (e.g., `UIImageView`).
    ///
    /// - returns: The child view if exists; otherwise nil.
    func subview(withClassName className: String) -> UIView? {
        if NSClassFromString(className) == self.dynamicType {
            return self
        }

        for view in subviews {
            if let subview = view.subview(withClassName: className) {
                return subview
            }
        }

        return nil
    }

    /// Prints `self` child view hierarchy.
    func debugSubviews(count: Int = 0) {
        if count == 0 {
            print("\n\n\n")
        }

        for _ in 0...count {
            print("--")
        }

        print("\(self.dynamicType)")

        for view in subviews {
            view.debugSubviews(count + 1)
        }

        if count == 0 {
            print("\n\n\n")
        }
    }
}

extension DynamicTableView {
    func expandCellReorderControl(willDisplayCell cell: UITableViewCell) {
        // The grip control customization
        // Credit: http://b2cloud.com.au/tutorial/reordering-a-uitableviewcell-from-any-touch-point
        guard let reorderControl = cell.subview(withClassName: "UITableViewCellReorderControl") else {
            return
        }

        let resizedGripView = UIView(frame: CGRect(x: 0, y: 0, width: reorderControl.frame.maxX, height: reorderControl.frame.maxY))
        resizedGripView.addSubview(reorderControl)
        cell.addSubview(resizedGripView)

        let sizeDifference = CGSizeMake(resizedGripView.frame.size.width - reorderControl.frame.size.width, resizedGripView.frame.size.height - reorderControl.frame.size.height)
        let transformRatio = CGSizeMake(resizedGripView.frame.size.width / reorderControl.frame.size.width, resizedGripView.frame.size.height / reorderControl.frame.size.height)

        //	Original transform
        var transform = CGAffineTransformIdentity

        //	Scale custom view so grip will fill entire cell
        transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height)

        //	Move custom view so the grip's top left aligns with the cell's top left
        transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2, -sizeDifference.height / 2)

        resizedGripView.transform = transform

        for cellGrip in reorderControl.subviews {
            if let cellGrip = cellGrip as? UIImageView {
                cellGrip.image = nil
            }
        }
    }
}
