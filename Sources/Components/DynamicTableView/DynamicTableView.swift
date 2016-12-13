//
// DynamicTableView.swift
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
import BEMCheckBox

open class DynamicTableView: ReorderTableView, UITableViewDelegate, UITableViewDataSource {
    fileprivate let reuseIdentifier = DynamicTableViewCell.reuseIdentifier
    fileprivate var allowReordering: Bool { return cellOptions.contains(.movable) }
    fileprivate var allowDeletion: Bool   { return cellOptions.contains(.deletable) }
    open var sections: [Section<DynamicTableModel>] = []
    open var cellOptions: DynamicTableCellOptions = [] {
        didSet { canReorder = allowReordering }
    }
    open dynamic var rowActionDeleteColor: UIColor?
    /// Text to display in the swipe to delete row action. The default value is **"Delete"**.
    open dynamic var rowActionDeleteTitle = "Delete"
    /// A boolean value to determine whether the content is centered in the table view. The default value is `false`.
    open dynamic var isContentCentered = false
    /// A boolean value to determine whether the last table view cell separator is hidden. The default value is `false`.
    open dynamic var isLastCellSeparatorHidden = false
    /// A boolean value to determine whether the empty table view cells are hidden. The default value is `false`.
    open dynamic var emptyCellsHidden = false {
        didSet { tableFooterView = emptyCellsHidden ? UIView(frame: .zero) : nil }
    }

    fileprivate var configureCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func configureCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        configureCell = callback
    }

    fileprivate var willDisplayCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func willDisplayCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        willDisplayCell = callback
    }

    fileprivate var configureHeader: ((_ section: Int, _ header: UITableViewHeaderFooterView, _ text: String?) -> Void)?
    open func configureHeader(_ callback: @escaping (_ section: Int, _ header: UITableViewHeaderFooterView, _ text: String?) -> Void) {
        configureHeader = callback
    }

    fileprivate var configureFooter: ((_ section: Int, _ footer: UITableViewHeaderFooterView, _ text: String?) -> Void)?
    open func configureFooter(_ callback: @escaping (_ section: Int, _ footer: UITableViewHeaderFooterView, _ text: String?) -> Void) {
        configureFooter = callback
    }

    fileprivate var didSelectItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didSelectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didSelectItem = callback
    }

    fileprivate var didDeselectItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didDeselectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didDeselectItem = callback
    }

    fileprivate var didRemoveItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didRemoveItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didRemoveItem = callback
    }

    fileprivate var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didMoveItem(_ callback: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didMoveItem = callback
    }

    fileprivate var editActionsForCell: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> [UITableViewRowAction]?)?
    open func editActionsForCell(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> [UITableViewRowAction]?) {
        editActionsForCell = callback
    }

    // MARK: Delegate

    /// We need to support two delegates for this class.
    ///
    /// 1. This class needs to be it's own delegate to provide default implementation using data source.
    /// 2. Outside client/classes can also become delegate to do further customizations.
    fileprivate weak var _delegate: UITableViewDelegate?
    override open var delegate: UITableViewDelegate? {
        get { return _delegate }
        set { self._delegate = newValue }
    }

    // MARK: Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, options: [])
    }

    public convenience init(style: UITableViewStyle) {
        self.init(style: style, options: [])
    }

    public convenience init(frame: CGRect = .zero, style: UITableViewStyle = .plain, options: DynamicTableCellOptions) {
        self.init(frame: frame, style: style)
        cellOptions = options
    }

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: isContentCentered

    fileprivate var shouldUpdateActualContentInset = true
    fileprivate var actualContentInset = UIEdgeInsets.zero
    open override var contentInset: UIEdgeInsets {
        didSet {
            guard shouldUpdateActualContentInset else { return }
            actualContentInset = contentInset
        }
    }

    open override func reloadData() {
        super.reloadData()
        centerContentIfNeeded()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        centerContentIfNeeded()
    }

    fileprivate func centerContentIfNeeded() {
        guard isContentCentered else { return }

        let totalHeight          = bounds.height
        let contentHeight        = contentSize.height
        let contentCanBeCentered = contentHeight < totalHeight

        shouldUpdateActualContentInset = false
        if contentCanBeCentered {
            contentInset.top = ceil(totalHeight / 2 - contentHeight / 2)
        } else {
            contentInset.top = actualContentInset.top
        }
        shouldUpdateActualContentInset = true
    }

    // MARK: Setup Methods

    fileprivate func commonInit() {
        setupTableView()
        setupSubviews()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// for example, add new subviews or configure properties.
    /// This method is called when self is initialized using any of the relevant `init` methods.
    open func setupSubviews() {}

    fileprivate func setupTableView() {
        super.delegate     = self
        dataSource         = self
        reorderDelegate    = self
        backgroundColor    = .clear
        estimatedRowHeight = 44
        rowHeight          = UITableViewAutomaticDimension
        canReorder         = allowReordering
        register(DynamicTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    open func overrideRegisteredClass(_ cellClass: DynamicTableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DynamicTableViewCell
        let item = sections[indexPath]
        cell.setData(item)
        configureAccessoryView(cell, type: item.accessory, indexPath: indexPath)

        if isLastCellSeparatorHidden {
            if indexPath.row == sections[indexPath.section].count - 1 {
                cell.separatorInset.left = UIDevice.ScreenSize.maxLength
            }
        }

        if item.userInfo[DynamicTableView.ReorderTableViewDummyItemIdentifier] == nil {
            configureCell?(indexPath, cell, item)
        }

        return cell
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DynamicTableViewCell else { return }
        let item = sections[indexPath]
        cell.cellWillAppear(indexPath, data: item)
        willDisplayCell?(indexPath, cell, item)
    }

    // Header

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    // Footer

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].detail
    }

    // MARK: UITableViewDelegate

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxView = tableView.cellForRow(at: indexPath)?.accessoryView as? BEMCheckBox {
                if checkboxView.on && (indexPathsForSelectedRows ?? []).contains(indexPath) {
                    deselectRow(at: indexPath, animated: true)
                    self.tableView(tableView, didDeselectRowAt: indexPath)
                    return
                }
                checkboxView.setOn(true, animated: true)
                callback?(checkboxView)
            }
        }
        didSelectItem?(indexPath, item)
        item.handler?(indexPath, item)
    }

    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxView = tableView.cellForRow(at: indexPath)?.accessoryView as? BEMCheckBox {
                checkboxView.setOn(false, animated: true)
                callback?(checkboxView)
            }
        }
        didDeselectItem?(indexPath, item)
    }

    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font      = headerFont
            header.textLabel?.textColor = headerTextColor
            configureHeader?(section, header, sections[section].title)
        }
    }

    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel?.font      = footerFont
            footer.textLabel?.textColor = footerTextColor
            configureFooter?(section, footer, sections[section].detail)
        }
    }

    // MARK: Reordering

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return allowReordering
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = sections.moveElement(from: sourceIndexPath, to: destinationIndexPath)
        didMoveItem?(sourceIndexPath, destinationIndexPath, movedItem)
    }

    // MARK: Deletion

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return allowReordering || allowDeletion || editActionsForCell != nil
    }

    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return allowDeletion
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return (allowDeletion || editActionsForCell != nil) ? .delete : .none
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if allowDeletion && editingStyle == .delete {
            removeItems([indexPath])
        }
    }

    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []

        if allowDeletion {
            let delete = UITableViewRowAction(style: .default, title: rowActionDeleteTitle) {[weak self] action, index in
                self?.removeItems([indexPath])
            }
            actions.append(delete)
            if let rowActionDeleteColor = rowActionDeleteColor {
                delete.backgroundColor = rowActionDeleteColor
            }
        }

        if let customActions = editActionsForCell?(indexPath, sections[indexPath]) {
            actions += customActions
        }

        return actions
    }

    // MARK: Helpers

    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion.
    ///
    /// - parameter indexPaths: An array of `IndexPath` objects identifying the rows to delete.
    /// - parameter animation:  A constant that indicates how the deletion is to be animated.
    fileprivate func removeItems(_ indexPaths: [IndexPath], animation: UITableViewRowAnimation = .automatic) {
        let items = indexPaths.map { (indexPath: $0, item: sections.remove(at: $0)) }
        CATransaction.animationTransaction({
            deleteRows(at: indexPaths, with: animation)
        }, completionHandler: {[weak self] in
            guard let weakSelf = self else { return }
            items.forEach { indexPath, item in
                weakSelf.didRemoveItem?(indexPath, item)
            }
        })
    }

    open override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        super.deselectRow(at: indexPath, animated: animated)
        let item = sections[indexPath]
        if case .checkbox = item.accessory {
            checkboxAccessoryView(at: indexPath)?.setOn(false, animated: animated)
        }
    }

    // MARK: UIAppearance Properties

    open dynamic var headerFont                   = UIFont.systemFont(.footnote)
    open dynamic var headerTextColor              = UIColor.black
    open dynamic var footerFont                   = UIFont.systemFont(.footnote)
    open dynamic var footerTextColor              = UIColor.darkGray
    open dynamic var accessoryFont                = UIFont.systemFont(.subheadline)
    open dynamic var accessoryTextColor           = UIColor.gray
    open dynamic var accessoryTextFrame           = CGRect(x: 0, y: 0, width: 50, height: 50)
    open dynamic var accessoryTintColor           = UIColor.defaultSystemTintColor()
    open dynamic var disclosureIndicatorTintColor = UIColor.gray
    /// The color of the check box ring when the checkbox is Off. The default value is `UIColor.blackColor().colorWithAlphaComponent(0.13)`.
    open dynamic var checkboxOffTintColor         = UIColor.black.alpha(0.13)
}

// MARK: AccessoryView

extension DynamicTableView: BEMCheckBoxDelegate {
    fileprivate func configureAccessoryView(_ cell: DynamicTableViewCell, type: DynamicTableAccessoryType, indexPath: IndexPath) {
        cell.accessoryType  = .none
        cell.selectionStyle = .default
        cell.accessoryView  = nil

        switch type {
            case .none:
                break
            case .disclosureIndicator:
                cell.accessoryView = UIImageView(assetIdentifier: .DisclosureIndicator)
                cell.accessoryView?.tintColor = disclosureIndicatorTintColor
            case .`switch`(let isOn, _):
                cell.selectionStyle  = .none
                let accessorySwitch  = UISwitch()
                accessorySwitch.isOn = isOn
                accessorySwitch.addAction(.valueChanged) {[weak self] sender in
                    guard let weakSelf = self else { return }
                    let accessory = weakSelf.sections[indexPath].accessory
                    if case .`switch`(_, let callback) = accessory {
                        callback?(sender)
                    }
                }
                cell.accessoryView = accessorySwitch
            case .checkbox(let isOn, _):
                cell.selectionStyle               = .none
                let checkbox                      = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                checkbox.on                       = isOn
                checkbox.lineWidth                = 1
                checkbox.tintColor                = checkboxOffTintColor
                checkbox.onTintColor              = accessoryTintColor
                checkbox.onFillColor              = accessoryTintColor
                checkbox.onCheckColor             = .white
                checkbox.onAnimationType          = .fill
                checkbox.offAnimationType         = .fill
                checkbox.animationDuration        = 0.4
                checkbox.delegate                 = self
                checkbox.indexPath                = indexPath
                checkbox.isUserInteractionEnabled = false
                cell.accessoryView                = checkbox
            case .text(let text):
                let label           = UILabel(frame: accessoryTextFrame)
                label.text          = text
                label.font          = accessoryFont
                label.textAlignment = .right
                label.textColor     = accessoryTextColor
                label.numberOfLines = 0
                cell.accessoryView  = label
            case .custom(let view):
                cell.accessoryView = view
        }
    }

    // MARK: Handle Switch changes

    public func didTap(_ checkBox: BEMCheckBox) {
        if let indexPath = checkBox.indexPath {
            let accessory = sections[indexPath].accessory
            if case .checkbox(_, let callback) = accessory {
                callback?(checkBox)
            }
        }
    }
}

// MARK: Convenience API

extension DynamicTableView {
    /// A convenience property to create a single section table view.
    open var items: [DynamicTableModel] {
        get { return sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }

    /// A convenience method to access `UISwitch` at the specified index path.
    public func switchAccessoryView(at indexPath: IndexPath) -> UISwitch? {
        if let switchAccessoryView = cellForRow(at: indexPath)?.accessoryView as? UISwitch {
            return switchAccessoryView
        }

        return nil
    }

    /// A convenience method to access `BEMCheckBox` at the specified index path.
    public func checkboxAccessoryView(at indexPath: IndexPath) -> BEMCheckBox? {
        if let checkboxAccessoryView = cellForRow(at: indexPath)?.accessoryView as? BEMCheckBox {
            return checkboxAccessoryView
        }

        return nil
    }

    /// A convenience method to access `accessoryView` at the specified index path.
    public func accessoryView(at indexPath: IndexPath) -> UIView? {
        if let accessoryView = cellForRow(at: indexPath)?.accessoryView {
            return accessoryView
        }

        return nil
    }
}

// MARK: ReorderTableViewDelegate

extension DynamicTableView: ReorderTableViewDelegate {
    fileprivate static let ReorderTableViewDummyItemIdentifier = "_Xcore_ReorderTableView_Dummy_Item_Identifier_"

    // This method is called when starting the re-ording process. You insert a blank row object into your
    // data source and return the object you want to save for later. This method is only called once.
    open func saveObjectAndInsertBlankRow(at indexPath: IndexPath) -> Any {
        let item = sections[indexPath]
        sections[indexPath] = DynamicTableModel(userInfo: [DynamicTableView.ReorderTableViewDummyItemIdentifier: true])
        return item
    }

    // This method is called when the selected row is dragged to a new position. You simply update your
    // data source to reflect that the rows have switched places. This can be called multiple times
    // during the reordering process.
    open func draggedRow(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        sections.moveElement(from: fromIndexPath, to: toIndexPath)
    }

    // This method is called when the selected row is released to its new position. The object is the same
    // object you returned in `saveObjectAndInsertBlankRow:atIndexPath:`. Simply update the data source so the
    // object is in its new position. You should do any saving/cleanup here.
    open func finishedDragging(fromIndexPath: IndexPath, toIndexPath: IndexPath, withObject object: Any) {
        items[toIndexPath.row] = object as! DynamicTableModel
        didMoveItem?(fromIndexPath, toIndexPath, items[toIndexPath.row])
    }
}

// MARK: UIScrollViewDelegate Forward Calls

extension DynamicTableView {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _delegate?.scrollViewDidScroll?(scrollView)
    }

    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        _delegate?.scrollViewDidZoom?(scrollView)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _delegate?.scrollViewWillBeginDragging?(scrollView)
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        _delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        _delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        _delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _delegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    @objc(viewForZoomingInScrollView:)
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return _delegate?.viewForZooming?(in: scrollView)
    }

    @objc(scrollViewWillBeginZooming:withView:)
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        _delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    @objc(scrollViewDidEndZooming:withView:atScale:)
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        _delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return _delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        _delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

// MARK: Helper Extensions

import ObjectiveC

private struct AssociatedKey {
    static var bemCheckBoxIndexPath = "BEMCheckBoxIndexPath"
}

private extension BEMCheckBox {
    var indexPath: IndexPath? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.bemCheckBoxIndexPath) as? IndexPath }
        set { objc_setAssociatedObject(self, &AssociatedKey.bemCheckBoxIndexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
