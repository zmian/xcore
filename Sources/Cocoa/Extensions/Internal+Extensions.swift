//
// Internal+Extensions.swift
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

import Foundation

extension DynamicTableView {
    func expandCellReorderControl(willDisplayCell cell: UITableViewCell) {
        // The grip control customization
        // Credit: http://b2cloud.com.au/tutorial/reordering-a-uitableviewcell-from-any-touch-point
        guard let reorderControl = cell.firstSubview(withClassName: "UITableViewCellReorderControl") else {
            return
        }

        let resizedGripView = UIView(frame: CGRect(x: 0, y: 0, width: reorderControl.frame.maxX, height: reorderControl.frame.maxY))
        resizedGripView.addSubview(reorderControl)
        cell.addSubview(resizedGripView)

        let sizeDifference = CGSize(width: resizedGripView.frame.size.width - reorderControl.frame.size.width, height: resizedGripView.frame.size.height - reorderControl.frame.size.height)
        let transformRatio = CGSize(width: resizedGripView.frame.size.width / reorderControl.frame.size.width, height: resizedGripView.frame.size.height / reorderControl.frame.size.height)

        //	Original transform
        var transform = CGAffineTransform.identity

        //	Scale custom view so grip will fill entire cell
        transform = transform.scaledBy(x: transformRatio.width, y: transformRatio.height)

        //	Move custom view so the grip's top left aligns with the cell's top left
        transform = transform.translatedBy(x: -sizeDifference.width / 2, y: -sizeDifference.height / 2)

        resizedGripView.transform = transform

        for cellGrip in reorderControl.subviews {
            if let cellGrip = cellGrip as? UIImageView {
                cellGrip.image = nil
            }
        }
    }
}
