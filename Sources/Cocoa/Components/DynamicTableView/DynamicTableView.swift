//
// DynamicTableView.swift
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

open class DynamicTableView: ReorderTableView, UITableViewDelegate, UITableViewDataSource {
    private var allowsReordering: Bool { return cellOptions.contains(.move) }
    private var allowsDeletion: Bool { return cellOptions.contains(.delete) }
    open var sections: [Section<DynamicTableModel>] = []
    open var cellOptions: CellOptions = .none {
        didSet {
            isReorderingEnabled = allowsReordering
        }
    }

    @objc open dynamic var rowActionDeleteColor: UIColor?
    /// Text to display in the swipe to delete row action. The default value is **"Delete"**.
    @objc open dynamic var rowActionDeleteTitle = "Delete"
    /// A boolean value to determine whether the content is centered in the table view. The default value is `false`.
    @objc open dynamic var isContentCentered = false
    /// A boolean value to determine whether the last table view cell separator is hidden. The default value is `false`.
    @objc open dynamic var isLastCellSeparatorHidden = false

    private var emptyTableFooterView = UIView()
    /// A boolean value to determine whether the empty table view cells are hidden. The default value is `false`.
    @objc open dynamic var isEmptyCellsHidden = false {
        didSet {
            guard tableFooterView == nil || tableFooterView == emptyTableFooterView else {
                return
            }

            tableFooterView = isEmptyCellsHidden ? emptyTableFooterView : nil
        }
    }

    private var configureCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func configureCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        configureCell = callback
    }

    private var willDisplayCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func willDisplayCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        willDisplayCell = callback
    }

    private var configureHeader: ((_ section: Int, _ headerView: UITableViewHeaderFooterView, _ text: String?) -> Void)?
    open func configureHeader(_ callback: @escaping (_ section: Int, _ headerView: UITableViewHeaderFooterView, _ text: String?) -> Void) {
        configureHeader = callback
    }

    private var configureFooter: ((_ section: Int, _ footerView: UITableViewHeaderFooterView, _ text: String?) -> Void)?
    open func configureFooter(_ callback: @escaping (_ section: Int, _ footerView: UITableViewHeaderFooterView, _ text: String?) -> Void) {
        configureFooter = callback
    }

    private var didSelectItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didSelectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didSelectItem = callback
    }

    private var didDeselectItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didDeselectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didDeselectItem = callback
    }

    private var didRemoveItem: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didRemoveItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didRemoveItem = callback
    }

    private var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: DynamicTableModel) -> Void)?
    open func didMoveItem(_ callback: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: DynamicTableModel) -> Void) {
        didMoveItem = callback
    }

    private var editActionsForCell: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> [UITableViewRowAction]?)?
    open func editActionsForCell(_ callback: @escaping (_ indexPath: IndexPath, _ item: DynamicTableModel) -> [UITableViewRowAction]?) {
        editActionsForCell = callback
    }

    // MARK: Delegate

    /// We need to support two delegates for this class.
    ///
    /// 1. This class needs to be it's own delegate to provide default implementation using data source.
    /// 2. Outside client/classes can also become delegate to do further customizations.
    private weak var _delegate: UITableViewDelegate?
    open var tableViewDelegate: UITableViewDelegate? {
        get { return _delegate }
        set { self._delegate = newValue }
    }

    // MARK: - Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, options: [])
    }

    public convenience init(style: Style) {
        self.init(style: style, options: [])
    }

    public convenience init(frame: CGRect = .zero, style: Style = .plain, options: CellOptions) {
        self.init(frame: frame, style: style)
        cellOptions = options
    }

    public override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        internalCommonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalCommonInit()
    }

    // MARK: - isContentCentered

    private var shouldUpdateActualContentInset = true
    private var actualContentInset: UIEdgeInsets = 0
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

    private func centerContentIfNeeded() {
        guard isContentCentered else { return }

        let totalHeight = bounds.height
        let contentHeight = contentSize.height
        let contentCanBeCentered = contentHeight < totalHeight

        shouldUpdateActualContentInset = false
        if contentCanBeCentered {
            contentInset.top = ceil(totalHeight / 2 - contentHeight / 2)
        } else {
            contentInset.top = actualContentInset.top
        }
        shouldUpdateActualContentInset = true
    }

    // MARK: - Setup Methods

    private func internalCommonInit() {
        setupTableView()
        commonInit()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() {}

    private func setupTableView() {
        super.delegate = self
        dataSource = self
        reorderDelegate = self
        backgroundColor = .clear
        estimatedRowHeight = 44
        rowHeight = UITableView.automaticDimension
        isReorderingEnabled = allowsReordering
    }

    open func overrideRegisteredClass(_ cell: DynamicTableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as DynamicTableViewCell
        let item = sections[indexPath]
        cell.configure(item)
        configureAccessoryView(cell, type: item.accessory, indexPath: indexPath)

        if isLastCellSeparatorHidden {
            if indexPath.row == sections[indexPath.section].count - 1 {
                cell.separatorInset.left = UIScreen.main.bounds.size.max
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

    // MARK: - UITableViewDelegate

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxButton = tableView.cellForRow(at: indexPath)?.accessoryView as? UIButton {
                if checkboxButton.isSelected && (indexPathsForSelectedRows ?? []).contains(indexPath) {
                    deselectRow(at: indexPath, animated: true)
                    self.tableView(tableView, didDeselectRowAt: indexPath)
                    return
                }
                checkboxButton.isSelected = true
                callback?(checkboxButton)
            }
        }
        didSelectItem?(indexPath, item)
        item.handler?(indexPath, item)
    }

    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = sections[indexPath]
        if case .checkbox(_, let callback) = item.accessory {
            if let checkboxButton = tableView.cellForRow(at: indexPath)?.accessoryView as? UIButton {
                checkboxButton.isSelected = false
                callback?(checkboxButton)
            }
        }
        didDeselectItem?(indexPath, item)
    }

    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }

        headerView.textLabel?.font = headerFont
        headerView.textLabel?.textColor = headerTextColor
        configureHeader?(section, headerView, sections[section].title)
    }

    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footerView = view as? UITableViewHeaderFooterView else {
            return
        }

        footerView.textLabel?.font = footerFont
        footerView.textLabel?.textColor = footerTextColor
        configureFooter?(section, footerView, sections[section].detail)
    }

    // MARK: - Reordering

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return allowsReordering
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = sections.moveElement(from: sourceIndexPath, to: destinationIndexPath)
        didMoveItem?(sourceIndexPath, destinationIndexPath, movedItem)
    }

    // MARK: - Deletion

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return allowsReordering || allowsDeletion || editActionsForCell != nil
    }

    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return allowsDeletion
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return (allowsDeletion || editActionsForCell != nil) ? .delete : .none
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard allowsDeletion && editingStyle == .delete else { return }
        removeItems([indexPath])
    }

    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []

        if allowsDeletion {
            let delete = UITableViewRowAction(style: .default, title: rowActionDeleteTitle) { [weak self] action, index in
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

    // MARK: - Helpers

    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion.
    ///
    /// - Parameters:
    ///   - indexPaths: An array of `IndexPath` objects identifying the rows to delete.
    ///   - animation:  A constant that indicates how the deletion is to be animated.
    private func removeItems(_ indexPaths: [IndexPath], animation: RowAnimation = .automatic) {
        let items = indexPaths.map { (indexPath: $0, item: sections.remove(at: $0)) }
        CATransaction.animationTransaction({
            deleteRows(at: indexPaths, with: animation)
        }, completionHandler: { [weak self] in
            guard let strongSelf = self else { return }
            items.forEach { indexPath, item in
                strongSelf.didRemoveItem?(indexPath, item)
            }
        })
    }

    open override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        super.deselectRow(at: indexPath, animated: animated)
        let item = sections[indexPath]
        if case .checkbox = item.accessory {
            checkboxAccessoryView(at: indexPath)?.isSelected = false
        }
    }

    // MARK: - UIAppearance Properties

    @objc open dynamic var headerFont: UIFont = .app(style: .caption1)
    @objc open dynamic var headerTextColor: UIColor = .black
    @objc open dynamic var footerFont: UIFont = .app(style: .caption1)
    @objc open dynamic var footerTextColor: UIColor = .darkGray
    @objc open dynamic var accessoryFont: UIFont = .app(style: .subheadline)
    @objc open dynamic var accessoryTextColor: UIColor = .appleGray
    @objc open dynamic var accessoryTintColor: UIColor = .appTint
    @objc open dynamic var accessoryTextMaxWidth: CGFloat = 0
    @objc open dynamic var disclosureIndicatorTintColor: UIColor = .appleGray

    /// The color of the check box ring when the checkbox is Off.
    /// The default value is `UIColor.blackColor().alpha(0.13)`.
    @objc open dynamic var checkboxOffTintColor = UIColor.black.alpha(0.13)
}

// MARK: - AccessoryView

extension DynamicTableView {
    private func configureAccessoryView(_ cell: DynamicTableViewCell, type: DynamicTableAccessoryType, indexPath: IndexPath) {
        cell.accessoryType = .none
        cell.selectionStyle = .default
        cell.accessoryView = nil

        switch type {
            case .none:
                break
            case .disclosureIndicator:
                cell.accessoryView = UIImageView(assetIdentifier: .disclosureIndicator)
                cell.accessoryView?.tintColor = disclosureIndicatorTintColor
            case .switch(let (isOn, callback)):
                cell.selectionStyle = .none
                let accessorySwitch = UISwitch()
                accessorySwitch.isOn = isOn
                accessorySwitch.addAction(.valueChanged) { sender in
                    callback?(sender)
                }
                cell.accessoryView = accessorySwitch
            case .checkbox(let (isSelected, _)):
                cell.selectionStyle = .none
                let accessoryCheckbox = UIButton(style: .checkbox(normalColor: checkboxOffTintColor, selectedColor: accessoryTintColor, textColor: footerTextColor, font: footerFont))
                accessoryCheckbox.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                accessoryCheckbox.isSelected = isSelected
                accessoryCheckbox.isUserInteractionEnabled = false
                cell.accessoryView = accessoryCheckbox
            case .text(let text):
                let label = UILabel()
                label.text = text
                label.font = accessoryFont
                label.textAlignment = .right
                label.textColor = accessoryTextColor
                label.numberOfLines = 0
                label.sizeToFit()
                if accessoryTextMaxWidth != 0, label.frame.width > accessoryTextMaxWidth {
                    label.frame.size.width = accessoryTextMaxWidth
                }
                cell.accessoryView = label
            case .custom(let view):
                cell.accessoryView = view
        }
    }
}

// MARK: - Convenience API

extension DynamicTableView {
    /// A convenience property to create a single section table view.
    open var items: [DynamicTableModel] {
        get { return sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }

    /// A convenience method to access `UISwitch` at the specified index path.
    public func switchAccessoryView(at indexPath: IndexPath) -> UISwitch? {
        return accessoryView(at: indexPath) as? UISwitch
    }

    /// A convenience method to access `UIButton` at the specified index path.
    public func checkboxAccessoryView(at indexPath: IndexPath) -> UIButton? {
        return accessoryView(at: indexPath) as? UIButton
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
    private static let ReorderTableViewDummyItemIdentifier = "_Xcore_ReorderTableView_Dummy_Item_Identifier_"

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
    open func draggedRow(from indexPath: IndexPath, toIndexPath: IndexPath) {
        sections.moveElement(from: indexPath, to: toIndexPath)
    }

    // This method is called when the selected row is released to its new position. The object is the same
    // object you returned in `saveObjectAndInsertBlankRow:atIndexPath:`. Simply update the data source so the
    // object is in its new position. You should do any saving/cleanup here.
    open func finishedDragging(from indexPath: IndexPath, toIndexPath: IndexPath, with object: Any) {
        items[toIndexPath.row] = object as! DynamicTableModel
        didMoveItem?(indexPath, toIndexPath, items[toIndexPath.row])
    }
}

// MARK: UIScrollViewDelegate Forward Calls

extension DynamicTableView {
    open override func responds(to aSelector: Selector!) -> Bool {
        if let delegate = _delegate, delegate.responds(to: aSelector) {
            return true
        }

        return super.responds(to: aSelector)
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let delegate = _delegate, delegate.responds(to: aSelector) {
            return _delegate
        }

        return super.forwardingTarget(for: aSelector)
    }
}
