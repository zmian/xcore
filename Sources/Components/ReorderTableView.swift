//
// ReorderTableView.swift
// Swift Port of https://github.com/bvogelzang/BVReorderTableView
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

import UIKit

private class ReorderTableDraggingView: BaseView {
    private let imageView             = UIImageView()
    private let topShadowImage        = UIImageView(assetIdentifier: .ReorderTableViewCellShadowTop)
    private let bottomShadowImage     = UIImageView(assetIdentifier: .ReorderTableViewCellShadowBottom)
    private let shadowHeight: CGFloat = 19

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    override func setupSubviews() {
        //userInteractionEnabled = false
        addSubview(topShadowImage)
        addSubview(imageView)
        addSubview(bottomShadowImage)

        clipsToBounds = false
        layer.masksToBounds = false

        NSLayoutConstraint.constraintsForViewToFillSuperview(imageView).activate()
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(topShadowImage).activate()
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(bottomShadowImage).activate()
        NSLayoutConstraint(item: topShadowImage, height: shadowHeight).activate()
        NSLayoutConstraint(item: bottomShadowImage, height: shadowHeight).activate()

        NSLayoutConstraint.constraintsWithVisualFormat("V:[topShadowImage][imageView]-(-1)-[bottomShadowImage]", options: [], metrics: nil, views: [
            "topShadowImage":    topShadowImage,
            "imageView":         imageView,
            "bottomShadowImage": bottomShadowImage
        ]).activate()
    }
}

public protocol ReorderTableViewDelegate: NSObjectProtocol {
    // This method is called when starting the re-ording process. You insert a blank row object into your
    // data source and return the object you want to save for later. This method is only called once.
    func saveObjectAndInsertBlankRow(atIndexPath indexPath: NSIndexPath) -> Any

    // This method is called when the selected row is dragged to a new position. You simply update your
    // data source to reflect that the rows have switched places. This can be called multiple times
    // during the reordering process.
    func draggedRow(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)

    // This method is called when the selected row is released to its new position. The object is the same
    // object you returned in `saveObjectAndInsertBlankRow:atIndexPath:`. Simply update the data source so the
    // object is in its new position. You should do any saving/cleanup here.
    func finishedDragging(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath, withObject object: Any)
}

public class ReorderTableView: UITableView {
    public weak var reorderDelegate: ReorderTableViewDelegate?
    public var canReorder: Bool = false {
        didSet { longPressGestureRecognizer.enabled = canReorder }
    }
    public var draggingViewOpacity: CGFloat = 0.8
    public var draggingRowHeight: CGFloat = 0

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    }()

    private var scrollRate: CGFloat = 0
    private var scrollDisplayLink: CADisplayLink?
    private var draggingView: ReorderTableDraggingView?
    private var currentLocationIndexPath: NSIndexPath?
    private var initialIndexPath: NSIndexPath?
    private var savedObject: Any?

    // MARK: Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: .Plain)
    }

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addGestureRecognizer(longPressGestureRecognizer)
    }

    private func updateCurrentLocation(gesture: UILongPressGestureRecognizer) {
        let location = gesture.locationInView(self)

        guard
            var indexPath                = indexPathForRowAtPoint(location),
            let initialIndexPath         = initialIndexPath,
            let currentLocationIndexPath = currentLocationIndexPath
        else { return }

        if let targetTndexPath = delegate?.tableView?(self, targetIndexPathForMoveFromRowAtIndexPath: initialIndexPath, toProposedIndexPath: indexPath) {
            indexPath = targetTndexPath
        }

        let oldHeight    = rectForRowAtIndexPath(currentLocationIndexPath).size.height
        let newHeight    = rectForRowAtIndexPath(indexPath).size.height
        let cellLocation = gesture.locationInView(cellForRowAtIndexPath(indexPath))

        if (indexPath != currentLocationIndexPath && cellLocation.y > newHeight - oldHeight) {
            beginUpdates()
            deleteRowsAtIndexPaths([currentLocationIndexPath], withRowAnimation: .Automatic)
            insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            if let reorderDelegate = reorderDelegate {
                reorderDelegate.draggedRow(fromIndexPath: currentLocationIndexPath, toIndexPath: indexPath)
            } else {
                print("draggedRow:fromIndexPath:toIndexPath: is not implemented")
            }

            self.currentLocationIndexPath = indexPath
            endUpdates()
        }
    }

    @objc private func scrollTableWithCell(timer: NSTimer) {
        guard let draggingView = draggingView else {
            cancelGesture()
            return
        }

        let gesture       = longPressGestureRecognizer
        let location      = gesture.locationInView(self)
        let currentOffset = contentOffset
        var newOffset     = CGPoint(x: currentOffset.x, y: currentOffset.y + scrollRate * 10)
        
        if newOffset.y < -contentInset.top {
            newOffset.y = -contentInset.top
        } else if contentSize.height + contentInset.bottom < frame.size.height {
            newOffset = currentOffset
        } else if (newOffset.y > (contentSize.height + contentInset.bottom) - frame.size.height) {
            newOffset.y = (contentSize.height + contentInset.bottom) - frame.size.height
        }

        contentOffset = newOffset

        if (location.y >= 0 && location.y <= contentSize.height + 50) {
            draggingView.center = CGPoint(x: center.x, y: location.y)
        }

        updateCurrentLocation(gesture)
    }
    
    private func cancelGesture() {
        longPressGestureRecognizer.enabled = false
        longPressGestureRecognizer.enabled = true
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.locationInView(self)
        let rows     = numberOfRowsInAllSections

        // get out of here if the long press was not on a valid row or our table is empty
        guard rows > 0 else {
            cancelGesture()
            return
        }

        // Started
        if gesture.state == .Began {
            guard let indexPath = indexPathForRowAtPoint(location), cell = cellForRowAtIndexPath(indexPath) else {
                cancelGesture()
                return
            }

            // get out of here if the dataSource tableView:canMoveRowAtIndexPath: doesn't allow moving the row
            if let canMoveRowAtIndexPath = dataSource?.tableView?(self, canMoveRowAtIndexPath: indexPath) where canMoveRowAtIndexPath == false {
                cancelGesture()
                return
            }

            draggingRowHeight = cell.frame.size.height
            cell.setSelected(false, animated: false)
            cell.setHighlighted(false, animated: false)
            
            // make an image from the pressed tableview cell
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // create and image view that we will drag around the screen
            if draggingView == nil {
                draggingView        = ReorderTableDraggingView()
                draggingView!.alpha = draggingViewOpacity
                draggingView!.image = cellImage
                let rect = rectForRowAtIndexPath(indexPath)
                draggingView!.frame  = rect
                draggingView!.center = CGPoint(x: center.x, y: location.y)
                addSubview(draggingView!)
            }

            beginUpdates()
            deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)

            if let reorderDelegate = reorderDelegate {
                savedObject = reorderDelegate.saveObjectAndInsertBlankRow(atIndexPath: indexPath)
            } else {
                print("saveObjectAndInsertBlankRow:atIndexPath: is not implemented")
            }

            self.currentLocationIndexPath = indexPath
            self.initialIndexPath = indexPath
            endUpdates()

            // enable scrolling for cell
            scrollDisplayLink = CADisplayLink(target: self, selector: #selector(scrollTableWithCell(_:)))
            scrollDisplayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }

        // Dragging
        else if gesture.state == .Changed {
            guard let draggingView = draggingView else {
                cancelGesture()
                return
            }

            // update position of the drag view
            // don't let it go past the top or the bottom too far
            if (location.y >= 0 && location.y <= contentSize.height + 50) {
                draggingView.center = CGPoint(x: center.x, y: location.y)
            }

            // adjust rect for content inset as we will use it below for calculating scroll zones
            var rect = bounds
            rect.size.height -= contentInset.top
            updateCurrentLocation(gesture)

            // tell us if we should scroll and which direction
            let scrollZoneHeight = rect.size.height / 6
            let bottomScrollBeginning = contentOffset.y + contentInset.top + rect.size.height - scrollZoneHeight
            let topScrollBeginning = contentOffset.y + contentInset.top  + scrollZoneHeight

            // we're in the bottom zone
            if (location.y >= bottomScrollBeginning) {
                scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight
            }
            // we're in the top zone
            else if (location.y <= topScrollBeginning) {
                scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight
            }
            else {
                scrollRate = 0
            }
        }
        // Dropped
        else if gesture.state == .Ended {
            guard let indexPath = currentLocationIndexPath, draggingView = draggingView else {
                cancelGesture()
                return
            }

            // remove scrolling CADisplayLink
            scrollDisplayLink?.invalidate()
            scrollDisplayLink = nil
            scrollRate = 0
            
            // animate the drag view to the newly hovered cell
            UIView.animateWithDuration(0.3,
            animations: {[weak self] in
                guard let weakSelf = self else { return }
                let rect = weakSelf.rectForRowAtIndexPath(indexPath)
                draggingView.transform = CGAffineTransformIdentity
                draggingView.frame = CGRectOffset(draggingView.bounds, rect.origin.x, rect.origin.y)
            }, completion: {[weak self] finished in
                guard let weakSelf = self else { return }

                draggingView.removeFromSuperview()

                weakSelf.beginUpdates()
                weakSelf.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                weakSelf.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)

                if let reorderDelegate = weakSelf.reorderDelegate, savedObject = weakSelf.savedObject, initialIndexPath = weakSelf.initialIndexPath {
                    reorderDelegate.finishedDragging(fromIndexPath: initialIndexPath, toIndexPath: indexPath, withObject: savedObject)
                } else {
                    print("finishedDragging:fromIndexPath:toIndexPath:withObject: is not implemented")
                }

                weakSelf.endUpdates()

                // reload the rows that were affected just to be safe
                var visibleRows = weakSelf.indexPathsForVisibleRows ?? []
                visibleRows.remove(indexPath)
                weakSelf.reloadRowsAtIndexPaths(visibleRows, withRowAnimation: .None)

                weakSelf.currentLocationIndexPath = nil
                weakSelf.draggingView = nil
            })
        }
    }
}

// MARK: Helpers

private extension UITableView {
    /// The total number of rows in all the sections.
    var numberOfRowsInAllSections: Int {
        var rows = 0
        for i in 0..<numberOfSections {
            rows += numberOfRowsInSection(i)
        }
        return rows
    }
}
