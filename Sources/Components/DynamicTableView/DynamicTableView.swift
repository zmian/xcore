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

public class DynamicTableView: ReorderTableView, UITableViewDelegate, UITableViewDataSource {
    private let reuseIdentifier = DynamicTableViewCell.reuseIdentifier
    private var allowReordering: Bool { return cellOptions.contains(.movable) }
    private var allowDeletion: Bool   { return cellOptions.contains(.deletable) }
    public var sections: [Section<DynamicTableModel>] = []
    public var cellOptions: DynamicTableCellOptions = [] {
        didSet { canReorder = allowReordering }
    }
    public dynamic var rowActionDeleteColor: UIColor?
    /// Text to display in the swipe to delete row action. The default value is **"Delete"**.
    public dynamic var rowActionDeleteTitle = "Delete"
    /// A boolean value to determine whether the content is centered in the table view. The default value is `false`.
    public dynamic var isContentCentered = false
    /// A boolean value to determine whether the last table view cell separator is hidden. The default value is `false`.
    public dynamic var isLastCellSeparatorHidden = false
    /// A boolean value to determine whether the empty table view cells are hidden. The default value is `false`.
    public dynamic var emptyCellsHidden = false {
        didSet { tableFooterView = emptyCellsHidden ? UIView(frame: .zero) : nil }
    }

    private var configureCell: ((indexPath: NSIndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) -> Void)?
    public func configureCell(callback: (indexPath: NSIndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) -> Void) {
        configureCell = callback
    }

    private var willDisplayCell: ((indexPath: NSIndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) -> Void)?
    public func willDisplayCell(callback: (indexPath: NSIndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) -> Void) {
        willDisplayCell = callback
    }

    private var configureHeader: ((section: Int, header: UITableViewHeaderFooterView, text: String?) -> Void)?
    public func configureHeader(callback: (section: Int, header: UITableViewHeaderFooterView, text: String?) -> Void) {
        configureHeader = callback
    }

    private var configureFooter: ((section: Int, footer: UITableViewHeaderFooterView, text: String?) -> Void)?
    public func configureFooter(callback: (section: Int, footer: UITableViewHeaderFooterView, text: String?) -> Void) {
        configureFooter = callback
    }

    private var didSelectItem: ((indexPath: NSIndexPath, item: DynamicTableModel) -> Void)?
    public func didSelectItem(callback: (indexPath: NSIndexPath, item: DynamicTableModel) -> Void) {
        didSelectItem = callback
    }

    private var didDeselectItem: ((indexPath: NSIndexPath, item: DynamicTableModel) -> Void)?
    public func didDeselectItem(callback: (indexPath: NSIndexPath, item: DynamicTableModel) -> Void) {
        didDeselectItem = callback
    }

    private var didRemoveItem: ((indexPath: NSIndexPath, item: DynamicTableModel) -> Void)?
    public func didRemoveItem(callback: (indexPath: NSIndexPath, item: DynamicTableModel) -> Void) {
        didRemoveItem = callback
    }

    private var didMoveItem: ((sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath, item: DynamicTableModel) -> Void)?
    public func didMoveItem(callback: (sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath, item: DynamicTableModel) -> Void) {
        didMoveItem = callback
    }

    private var editActionsForCell: ((indexPath: NSIndexPath, item: DynamicTableModel) -> [UITableViewRowAction]?)?
    public func editActionsForCell(callback: (indexPath: NSIndexPath, item: DynamicTableModel) -> [UITableViewRowAction]?) {
        editActionsForCell = callback
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

    public convenience init(frame: CGRect = .zero, style: UITableViewStyle = .Plain, options: DynamicTableCellOptions) {
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

    private var shouldUpdateActualContentInset = true
    private var actualContentInset = UIEdgeInsets.zero
    public override var contentInset: UIEdgeInsets {
        didSet {
            guard shouldUpdateActualContentInset else { return }
            actualContentInset = contentInset
        }
    }

    public override func reloadData() {
        super.reloadData()
        centerContentIfNeeded()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        centerContentIfNeeded()
    }

    private func centerContentIfNeeded() {
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

    private func commonInit() {
        setupTableView()
        setupSubviews()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// for example, add new subviews or configure properties.
    /// This method is called when self is initialized using any of the relevant `init` methods.
    public func setupSubviews() {}

    private func setupTableView() {
        delegate           = self
        dataSource         = self
        reorderDelegate    = self
        backgroundColor    = UIColor.clearColor()
        estimatedRowHeight = 44
        rowHeight          = UITableViewAutomaticDimension
        canReorder         = allowReordering
        registerClass(DynamicTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    public func overrideRegisteredClass(cellClass: DynamicTableViewCell.Type) {
        registerClass(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: UITableViewDataSource

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DynamicTableViewCell
        let item = sections[indexPath]
        cell.setData(item)
        configureAccessoryView(cell, type: item.accessory, indexPath: indexPath)

        if isLastCellSeparatorHidden {
            if indexPath.row == sections[indexPath.section].count - 1 {
                cell.separatorInset.left = UIDevice.ScreenSize.maxLength
            }
        }

        if item.userInfo[DynamicTableView.ReorderTableViewDummyItemIdentifier] == nil {
            configureCell?(indexPath: indexPath, cell: cell, item: item)
        }

        return cell
    }

    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? DynamicTableViewCell else { return }
        let item = sections[indexPath]
        cell.cellWillAppear(indexPath, data: item)
        willDisplayCell?(indexPath: indexPath, cell: cell, item: item)
    }

    // Header

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    // Footer

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].detail
    }

    // MARK: UITableViewDelegate

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxView = tableView.cellForRowAtIndexPath(indexPath)?.accessoryView as? BEMCheckBox {
                if checkboxView.on && (indexPathsForSelectedRows ?? []).contains(indexPath) {
                    deselectRowAtIndexPath(indexPath, animated: true)
                    self.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
                    return
                }
                checkboxView.setOn(true, animated: true)
                callback?(sender: checkboxView)
            }
        }
        didSelectItem?(indexPath: indexPath, item: item)
        item.handler?(indexPath: indexPath, item: item)
    }

    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxView = tableView.cellForRowAtIndexPath(indexPath)?.accessoryView as? BEMCheckBox {
                checkboxView.setOn(false, animated: true)
                callback?(sender: checkboxView)
            }
        }
        didDeselectItem?(indexPath: indexPath, item: item)
    }

    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font      = headerFont
            header.textLabel?.textColor = headerTextColor
            configureHeader?(section: section, header: header, text: sections[section].title)
        }
    }

    public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel?.font      = footerFont
            footer.textLabel?.textColor = footerTextColor
            configureFooter?(section: section, footer: footer, text: sections[section].detail)
        }
    }

    // MARK: Reordering

    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowReordering
    }

    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedItem = sections.moveElement(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
        didMoveItem?(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath, item: movedItem)
    }

    // MARK: Deletion

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowReordering || allowDeletion || editActionsForCell != nil
    }

    public func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowDeletion
    }

    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return (allowDeletion || editActionsForCell != nil) ? .Delete : .None
    }

    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if allowDeletion && editingStyle == .Delete {
            removeItems([indexPath])
        }
    }

    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []

        if allowDeletion {
            let delete = UITableViewRowAction(style: .Destructive, title: rowActionDeleteTitle) {[weak self] action, index in
                self?.removeItems([indexPath])
            }
            actions.append(delete)
            if let rowActionDeleteColor = rowActionDeleteColor {
                delete.backgroundColor = rowActionDeleteColor
            }
        }

        if let customActions = editActionsForCell?(indexPath: indexPath, item: sections[indexPath]) {
            actions += customActions
        }

        return actions
    }

    // MARK: Helpers

    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion.
    ///
    /// - parameter indexPaths: An array of NSIndexPath objects identifying the rows to delete.
    /// - parameter animation:  A constant that indicates how the deletion is to be animated.
    private func removeItems(indexPaths: [NSIndexPath], animation: UITableViewRowAnimation = .Automatic) {
        let items = indexPaths.map { (indexPath: $0, item: sections.removeAt($0)) }
        CATransaction.animationTransaction({
            deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        }, completionHandler: {[weak self] in
            guard let weakSelf = self else { return }
            items.forEach { indexPath, item in
                weakSelf.didRemoveItem?(indexPath: indexPath, item: item)
            }
        })
    }

    public override func deselectRowAtIndexPath(indexPath: NSIndexPath, animated: Bool) {
        super.deselectRowAtIndexPath(indexPath, animated: animated)
        let item = sections[indexPath]
        if case .checkbox = item.accessory {
            checkboxAccessoryView(atIndexPath: indexPath)?.setOn(false, animated: animated)
        }
    }

    // MARK: UIAppearance Properties

    public dynamic var headerFont                   = UIFont.systemFont(.footnote)
    public dynamic var headerTextColor              = UIColor.blackColor()
    public dynamic var footerFont                   = UIFont.systemFont(.footnote)
    public dynamic var footerTextColor              = UIColor.darkGrayColor()
    public dynamic var accessoryFont                = UIFont.systemFont(.subheadline)
    public dynamic var accessoryTextColor           = UIColor.grayColor()
    public dynamic var accessoryTextFrame           = CGRect(x: 0, y: 0, width: 50, height: 50)
    public dynamic var accessoryTintColor           = UIColor.defaultSystemTintColor()
    public dynamic var disclosureIndicatorTintColor = UIColor.grayColor()
    /// The color of the check box ring when the checkbox is Off. The default value is `UIColor.blackColor().colorWithAlphaComponent(0.13)`.
    public dynamic var checkboxOffTintColor         = UIColor.blackColor().alpha(0.13)
}

// MARK: AccessoryView

extension DynamicTableView: BEMCheckBoxDelegate {
    private func configureAccessoryView(cell: DynamicTableViewCell, type: DynamicTableAccessoryType, indexPath: NSIndexPath) {
        cell.accessoryType  = .None
        cell.selectionStyle = .Default
        cell.accessoryView  = nil

        switch type {
            case .none:
                break
            case .disclosureIndicator:
                cell.accessoryView = UIImageView(assetIdentifier: .DisclosureIndicator)
                cell.accessoryView?.tintColor = disclosureIndicatorTintColor
            case .`switch`(let isOn, _):
                cell.selectionStyle = .None
                let accessorySwitch = UISwitch()
                accessorySwitch.on  = isOn
                accessorySwitch.addAction(.ValueChanged) {[weak self] sender in
                    guard let weakSelf = self else { return }
                    let accessory = weakSelf.sections[indexPath].accessory
                    if case .`switch`(_, let callback) = accessory {
                        callback?(sender: sender)
                    }
                }
                cell.accessoryView = accessorySwitch
            case .checkbox(let isOn, _):
                cell.selectionStyle             = .None
                let checkbox                    = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                checkbox.on                     = isOn
                checkbox.lineWidth              = 1
                checkbox.tintColor              = checkboxOffTintColor
                checkbox.onTintColor            = accessoryTintColor
                checkbox.onFillColor            = accessoryTintColor
                checkbox.onCheckColor           = UIColor.whiteColor()
                checkbox.onAnimationType        = .Fill
                checkbox.offAnimationType       = .Fill
                checkbox.animationDuration      = 0.4
                checkbox.delegate               = self
                checkbox.indexPath              = indexPath
                checkbox.userInteractionEnabled = false
                cell.accessoryView              = checkbox
            case .text(let text):
                let label           = UILabel(frame: accessoryTextFrame)
                label.text          = text
                label.font          = accessoryFont
                label.textAlignment = .Right
                label.textColor     = accessoryTextColor
                label.numberOfLines = 0
                cell.accessoryView = label
            case .custom(let view):
                cell.accessoryView = view
        }
    }

    // MARK: Handle Switch changes

    public func didTapCheckBox(checkBox: BEMCheckBox) {
        if let indexPath = checkBox.indexPath {
            let accessory = sections[indexPath].accessory
            if case .checkbox(_, let callback) = accessory {
                callback?(sender: checkBox)
            }
        }
    }
}

// MARK: Convenience API

public extension DynamicTableView {
    /// A convenience property to create a single section table view.
    public var items: [DynamicTableModel] {
        get { return sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }

    /// A convenience method to access `UISwitch` at the specified index path.
    public func switchAccessoryView(atIndexPath indexPath: NSIndexPath) -> UISwitch? {
        if let switchAccessoryView = cellForRowAtIndexPath(indexPath)?.accessoryView as? UISwitch {
            return switchAccessoryView
        }

        return nil
    }

    /// A convenience method to access `BEMCheckBox` at the specified index path.
    public func checkboxAccessoryView(atIndexPath indexPath: NSIndexPath) -> BEMCheckBox? {
        if let checkboxAccessoryView = cellForRowAtIndexPath(indexPath)?.accessoryView as? BEMCheckBox {
            return checkboxAccessoryView
        }

        return nil
    }

    /// A convenience method to access `accessoryView` at the specified index path.
    public func accessoryView(atIndexPath indexPath: NSIndexPath) -> UIView? {
        if let accessoryView = cellForRowAtIndexPath(indexPath)?.accessoryView {
            return accessoryView
        }

        return nil
    }
}

// MARK: ReorderTableViewDelegate

extension DynamicTableView: ReorderTableViewDelegate {
    private static let ReorderTableViewDummyItemIdentifier = "_Xcore_ReorderTableView_Dummy_Item_Identifier"

    // This method is called when starting the re-ording process. You insert a blank row object into your
    // data source and return the object you want to save for later. This method is only called once.
    public func saveObjectAndInsertBlankRow(atIndexPath indexPath: NSIndexPath) -> Any {
        let item = sections[indexPath]
        sections[indexPath] = DynamicTableModel(userInfo: [DynamicTableView.ReorderTableViewDummyItemIdentifier: true])
        return item
    }

    // This method is called when the selected row is dragged to a new position. You simply update your
    // data source to reflect that the rows have switched places. This can be called multiple times
    // during the reordering process.
    public func draggedRow(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        sections.moveElement(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
    }

    // This method is called when the selected row is released to its new position. The object is the same
    // object you returned in `saveObjectAndInsertBlankRow:atIndexPath:`. Simply update the data source so the
    // object is in its new position. You should do any saving/cleanup here.
    public func finishedDragging(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath, withObject object: Any) {
        items[toIndexPath.row] = object as! DynamicTableModel
        didMoveItem?(sourceIndexPath: fromIndexPath, destinationIndexPath: toIndexPath, item: items[toIndexPath.row])
    }
}

// MARK: Helper Extensions

import ObjectiveC

private struct AssociatedKey {
    static var BEMCheckBoxIndexPath = "BEMCheckBoxIndexPath"
}

private extension BEMCheckBox {
    var indexPath: NSIndexPath? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.BEMCheckBoxIndexPath) as? NSIndexPath }
        set { objc_setAssociatedObject(self, &AssociatedKey.BEMCheckBoxIndexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
