//
// Internal+Extensions.swift
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
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
