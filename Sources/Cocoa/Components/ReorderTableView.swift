//
// ReorderTableView.swift
// Swift Port of https://github.com/bvogelzang/BVReorderTableView
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

private class ReorderTableDraggingView: XCView {
    private let imageView = UIImageView()
    private let topShadowImage = UIImageView(assetIdentifier: .reorderTableViewCellShadowTop)
    private let bottomShadowImage = UIImageView(assetIdentifier: .reorderTableViewCellShadowBottom)
    private let shadowHeight: CGFloat = 19

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    var shadowAlpha: CGFloat = 1 {
        didSet {
            topShadowImage.alpha = shadowAlpha
            bottomShadowImage.alpha = shadowAlpha
        }
    }

    override func commonInit() {
        isUserInteractionEnabled = false
        addSubview(topShadowImage)
        addSubview(imageView)
        addSubview(bottomShadowImage)

        clipsToBounds = false
        layer.masksToBounds = false

        imageView.anchor.edges.equalToSuperview()

        topShadowImage.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.height.equalTo(shadowHeight)
        }

        bottomShadowImage.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.height.equalTo(shadowHeight)
        }

        NSLayoutConstraint.constraints(withVisualFormat: "V:[topShadowImage][imageView]-(-1)-[bottomShadowImage]", options: [], metrics: nil, views: [
            "topShadowImage": topShadowImage,
            "imageView": imageView,
            "bottomShadowImage": bottomShadowImage
        ]).activate()
    }
}

public protocol ReorderTableViewDelegate: NSObjectProtocol {
    /// This method is called when starting the re-ording process. You insert a blank row object into your
    /// data source and return the object you want to save for later. This method is only called once.
    func saveObjectAndInsertBlankRow(at indexPath: IndexPath) -> Any

    /// This method is called when the selected row is dragged to a new position. You simply update your
    /// data source to reflect that the rows have switched places. This can be called multiple times
    /// during the reordering process.
    func draggedRow(from indexPath: IndexPath, toIndexPath: IndexPath)

    /// This method is called when the selected row is released to its new position. The object is the same
    /// object you returned in `saveObjectAndInsertBlankRow:atIndexPath:`. Simply update the data source so the
    /// object is in its new position. You should do any saving/cleanup here.
    func finishedDragging(from indexPath: IndexPath, toIndexPath: IndexPath, with object: Any)
}

open class ReorderTableView: UITableView {
    private var scrollRate: CGFloat = 0
    private var scrollDisplayLink: CADisplayLink?
    private var draggingView: ReorderTableDraggingView?
    private var currentLocationIndexPath: IndexPath?
    private var initialIndexPath: IndexPath?
    private var savedObject: Any?
    private lazy var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    open weak var reorderDelegate: ReorderTableViewDelegate?
    /// The default value is `true`.
    open var isReorderingEnabled: Bool = true {
        didSet { longPressGestureRecognizer.isEnabled = isReorderingEnabled }
    }
    open var draggingRowHeight: CGFloat = 0
    @objc open dynamic var draggingViewOpacity: CGFloat = 0.8
    @objc open dynamic var draggingViewBackgroundColor: UIColor = .clear

    // MARK: - Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }

    public override init(frame: CGRect, style: Style) {
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

    private func updateCurrentLocation(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)

        guard
            var indexPath = indexPathForRow(at: location),
            let initialIndexPath = initialIndexPath,
            let currentLocationIndexPath = currentLocationIndexPath
        else { return }

        if let targetTndexPath = delegate?.tableView?(self, targetIndexPathForMoveFromRowAt: initialIndexPath, toProposedIndexPath: indexPath) {
            indexPath = targetTndexPath
        }

        let oldHeight = rectForRow(at: currentLocationIndexPath).size.height
        let newHeight = rectForRow(at: indexPath).size.height
        let cellLocation = gesture.location(in: cellForRow(at: indexPath))

        if indexPath != currentLocationIndexPath && cellLocation.y > newHeight - oldHeight {
            beginUpdates()
            deleteRows(at: [currentLocationIndexPath], with: .automatic)
            insertRows(at: [indexPath], with: .automatic)

            if let reorderDelegate = reorderDelegate {
                reorderDelegate.draggedRow(from: currentLocationIndexPath, toIndexPath: indexPath)
            } else {
                print("draggedRow:from:toIndexPath: is not implemented")
            }

            self.currentLocationIndexPath = indexPath
            endUpdates()
        }
    }

    @objc private func scrollTableWithCell(_ timer: Timer) {
        guard let draggingView = draggingView else {
            cancelGesture()
            return
        }

        let gesture = longPressGestureRecognizer
        let location = gesture.location(in: self)
        let currentOffset = contentOffset
        var newOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + scrollRate * 10)

        if newOffset.y < -contentInset.top {
            newOffset.y = -contentInset.top
        } else if contentSize.height + contentInset.bottom < frame.size.height {
            newOffset = currentOffset
        } else if newOffset.y > (contentSize.height + contentInset.bottom) - frame.size.height {
            newOffset.y = (contentSize.height + contentInset.bottom) - frame.size.height
        }

        contentOffset = newOffset

        if location.y >= 0 && location.y <= contentSize.height + 50 {
            draggingView.center = CGPoint(x: center.x, y: location.y)
        }

        updateCurrentLocation(gesture)
    }

    private func cancelGesture() {
        longPressGestureRecognizer.isEnabled = false
        longPressGestureRecognizer.isEnabled = true
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        let rows = numberOfRowsInAllSections

        // Get out of here if the long press was not on a valid row or our table is empty
        guard rows > 0 else {
            cancelGesture()
            return
        }

        // Started
        if gesture.state == .began {
            guard let indexPath = indexPathForRow(at: location), let cell = cellForRow(at: indexPath) else {
                cancelGesture()
                return
            }

            // Get out of here if the dataSource tableView:canMoveRowAtIndexPath: doesn't allow moving the row
            if let canMoveRowAtIndexPath = dataSource?.tableView?(self, canMoveRowAt: indexPath), canMoveRowAtIndexPath == false {
                cancelGesture()
                return
            }

            draggingRowHeight = cell.frame.size.height
            cell.setSelected(false, animated: false)
            cell.setHighlighted(false, animated: false)

            // Make an image from the pressed tableview cell
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // Create and image view that we will drag around the screen
            if draggingView == nil {
                draggingView = ReorderTableDraggingView()
                draggingView!.image = cellImage
                let rect = rectForRow(at: indexPath)
                draggingView!.frame = rect
                draggingView!.center = CGPoint(x: center.x, y: location.y)
                draggingView!.backgroundColor = draggingViewBackgroundColor
                draggingView!.alpha = draggingViewOpacity
                draggingView!.shadowAlpha = 0
                addSubview(draggingView!)
                UIView.animate(withDuration: 0.3) {
                    self.draggingView!.shadowAlpha = 1
                }
            }

            beginUpdates()
            deleteRows(at: [indexPath], with: .none)
            insertRows(at: [indexPath], with: .none)

            if let reorderDelegate = reorderDelegate {
                savedObject = reorderDelegate.saveObjectAndInsertBlankRow(at: indexPath)
            } else {
                print("saveObjectAndInsertBlankRow:atIndexPath: is not implemented")
            }

            self.currentLocationIndexPath = indexPath
            self.initialIndexPath = indexPath
            endUpdates()

            // Enable scrolling for cell
            scrollDisplayLink = CADisplayLink(target: self, selector: #selector(scrollTableWithCell(_:)))
            scrollDisplayLink?.add(to: .main, forMode: .default)
        }

        // Dragging
        else if gesture.state == .changed {
            guard let draggingView = draggingView else {
                cancelGesture()
                return
            }

            // Update position of the drag view and don't let it go past the top or the bottom too far
            if location.y >= 0 && location.y <= contentSize.height + 50 {
                draggingView.center = CGPoint(x: center.x, y: location.y)
            }

            // Adjust rect for content inset as we will use it below for calculating scroll zones
            var rect = bounds
            rect.size.height -= contentInset.top
            updateCurrentLocation(gesture)

            // Tell us if we should scroll and which direction
            let scrollZoneHeight = rect.size.height / 6
            let bottomScrollBeginning = contentOffset.y + contentInset.top + rect.size.height - scrollZoneHeight
            let topScrollBeginning = contentOffset.y + contentInset.top  + scrollZoneHeight

            // We're in the bottom zone
            if location.y >= bottomScrollBeginning {
                scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight
            }
            // We're in the top zone
            else if location.y <= topScrollBeginning {
                scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight
            } else {
                scrollRate = 0
            }
        }
        // Dropped
        else if gesture.state == .ended {
            guard let indexPath = currentLocationIndexPath, let draggingView = draggingView else {
                cancelGesture()
                return
            }

            // Remove scrolling CADisplayLink
            scrollDisplayLink?.invalidate()
            scrollDisplayLink = nil
            scrollRate = 0

            // Animate the drag view to the newly hovered cell
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let strongSelf = self else { return }
                let rect = strongSelf.rectForRow(at: indexPath)
                draggingView.transform = .identity
                draggingView.frame = draggingView.bounds.offsetBy(dx: rect.origin.x, dy: rect.origin.y)
            }, completion: { [weak self] _ in
                guard let strongSelf = self else { return }

                draggingView.setHidden(true, animated: true, duration: 0.3) {
                    draggingView.removeFromSuperview()
                }

                strongSelf.beginUpdates()
                strongSelf.deleteRows(at: [indexPath], with: .none)
                strongSelf.insertRows(at: [indexPath], with: .none)

                if let reorderDelegate = strongSelf.reorderDelegate, let savedObject = strongSelf.savedObject, let initialIndexPath = strongSelf.initialIndexPath {
                    reorderDelegate.finishedDragging(from: initialIndexPath, toIndexPath: indexPath, with: savedObject)
                } else {
                    print("finishedDragging:from:toIndexPath:with: is not implemented")
                }

                strongSelf.endUpdates()

                // Reload the rows that were affected just to be safe
                var visibleRows = strongSelf.indexPathsForVisibleRows ?? []
                visibleRows.remove(indexPath)
                strongSelf.reloadRows(at: visibleRows, with: .none)

                strongSelf.currentLocationIndexPath = nil
                strongSelf.draggingView = nil
            })
        }
    }
}
