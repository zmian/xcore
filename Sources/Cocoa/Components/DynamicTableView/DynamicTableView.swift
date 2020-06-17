//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class DynamicTableView: ReorderTableView, UITableViewDelegate, UITableViewDataSource {
    private var allowsReordering: Bool { cellOptions.contains(.move) }
    private var allowsDeletion: Bool { cellOptions.contains(.delete) }
    private let emptyTableFooterView = UIView()
    open var sections: [Section<DynamicTableModel>] = []
    open var cellOptions: CellOptions = .none {
        didSet {
            isReorderingEnabled = allowsReordering
        }
    }

    /// A boolean value to determine whether the empty table view cells are hidden. The default value is `false`.
    @objc open dynamic var isEmptyCellsHidden = false {
        didSet {
            guard tableFooterView == nil || tableFooterView == emptyTableFooterView else {
                return
            }

            tableFooterView = isEmptyCellsHidden ? emptyTableFooterView : nil
        }
    }

    // MARK: - UIAppearance Properties

    @objc open dynamic var rowActionDeleteColor: UIColor?
    /// Text to display in the swipe to delete row action. The default value is **"Delete"**.
    @objc open dynamic var rowActionDeleteTitle = "Delete"
    /// A boolean value to determine whether the content is centered in the table view. The default value is `false`.
    @objc open dynamic var isContentCentered = false
    /// A boolean value to determine whether the last table view cell separator is hidden. The default value is `false`.
    @objc open dynamic var isLastCellSeparatorHidden = false

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

    // MARK: - Hooks

    private var configureCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func configureCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        configureCell = callback
    }

    private var willDisplayCell: ((_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void)?
    open func willDisplayCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: DynamicTableViewCell, _ item: DynamicTableModel) -> Void) {
        willDisplayCell = callback
    }

    private var didScroll: ((_ tableView: DynamicTableView) -> Void)?
    open func didScroll(_ callback: @escaping (_ tableView: DynamicTableView) -> Void) {
        didScroll = callback
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

    // MARK: - Delegate

    /// We need to support two delegates for this class.
    ///
    /// 1. This class needs to be it's own delegate to provide default implementation using data source.
    /// 2. Outside client/classes can also become delegate to do further customizations.
    private weak var _delegate: UITableViewDelegate?
    open var tableViewDelegate: UITableViewDelegate? {
        get { _delegate }
        set { _delegate = newValue }
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
        // There is UIKit bug that causes `UITableView` to jump when using
        // `estimatedRowHeight` and reloading cells/sections or the entire table view.
        //
        // One solution is to overshoot the estimated row height which causes the table
        // view to properly calculate the height for cells.
        //
        // But, it still reports incorrect content size. Thus, we are implementing
        // autosizing cells using `custom sizing cell`.
        estimatedRowHeight = 0
        rowHeight = UITableView.automaticDimension
        isReorderingEnabled = allowsReordering
    }

    open func overrideRegisteredClass(_ cell: DynamicTableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as DynamicTableViewCell
        let item = sections[indexPath]
        cell.configure(item)
        configureAccessoryView(cell, type: item.accessory, indexPath: indexPath)

        if isLastCellSeparatorHidden {
            let isLastRow = indexPath.row == sections[indexPath.section].count - 1
            cell.separatorInset = UIEdgeInsets(left: isLastRow ? UIScreen.main.bounds.size.max : 0)
        }

        if item.userInfo[DynamicTableView.reorderTableViewDummyItemIdentifier] == nil {
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
        sections[section].title
    }

    // Footer

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].detail
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
        item.didSelect?(indexPath, item)
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
        allowsReordering
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = sections.moveElement(from: sourceIndexPath, to: destinationIndexPath)
        didMoveItem?(sourceIndexPath, destinationIndexPath, movedItem)
    }

    // MARK: - Deletion

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        allowsReordering || allowsDeletion || editActionsForCell != nil
    }

    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        allowsDeletion
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        (allowsDeletion || editActionsForCell != nil) ? .delete : .none
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
        CATransaction.animation({
            deleteRows(at: indexPaths, with: animation)
        }, completion: { [weak self] in
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

    // MARK: - Custom Self-sizing

    private let sizingCell = DynamicTableViewCell()

    private func cellHeight(for item: DynamicTableModel, width: CGFloat, indexPath: IndexPath) -> CGFloat {
        sizingCell.apply {
            $0.prepareForReuse()
            $0.configure(item)
            configureAccessoryView($0, type: item.accessory, indexPath: indexPath)
            $0.updateConstraints()
            $0.setNeedsLayout()
            $0.layoutIfNeeded()
        }
        let size = sizingCell.contentView.sizeFitting(width: width)
        return size.height
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight(for: sections[indexPath], width: bounds.width, indexPath: indexPath)
    }
}

// MARK: - UIScrollViewDelegate

extension DynamicTableView {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(self)
    }
}

// MARK: - AccessoryView

extension DynamicTableView {
    private func configureAccessoryView(_ cell: DynamicTableViewCell, type: ListAccessoryType, indexPath: IndexPath) {
        cell.accessoryType = .none
        cell.selectionStyle = .default
        cell.accessoryView = nil

        switch type {
            case .none:
                break
            case .disclosureIndicator:
                cell.accessoryView = UIImageView(assetIdentifier: .disclosureIndicator)
                cell.accessoryView?.tintColor = disclosureIndicatorTintColor
            case .toggle(let isOn, let callback):
                cell.selectionStyle = .none
                let accessorySwitch = UISwitch().apply {
                    $0.isOn = isOn
                    $0.addAction(.valueChanged) { sender in
                        callback?(sender)
                    }
                }
                cell.accessoryView = accessorySwitch
            case .checkbox(let isSelected, _):
                cell.selectionStyle = .none
                let accessoryCheckbox = UIButton(configuration: .checkbox(
                    normalColor: checkboxOffTintColor,
                    selectedColor: accessoryTintColor,
                    textColor: footerTextColor,
                    font: footerFont
                )).apply {
                    $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                    $0.isSelected = isSelected
                    $0.isUserInteractionEnabled = false
                }
                cell.accessoryView = accessoryCheckbox
            case .text(let text):
                let label = UILabel().apply {
                    $0.setText(text)
                    $0.font = accessoryFont
                    $0.textAlignment = .right
                    $0.textColor = accessoryTextColor
                    $0.numberOfLines = 0
                    $0.sizeToFit()
                    if accessoryTextMaxWidth != 0, $0.frame.width > accessoryTextMaxWidth {
                        $0.frame.size.width = accessoryTextMaxWidth
                    }
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
        get { sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }

    /// A convenience method to access `UISwitch` at the specified index path.
    public func switchAccessoryView(at indexPath: IndexPath) -> UISwitch? {
        accessoryView(at: indexPath) as? UISwitch
    }

    /// A convenience method to access `UIButton` at the specified index path.
    public func checkboxAccessoryView(at indexPath: IndexPath) -> UIButton? {
        accessoryView(at: indexPath) as? UIButton
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
    private static var reorderTableViewDummyItemIdentifier: String {
        "_Xcore_ReorderTableView_Dummy_Item_Identifier_"
    }

    // This method is called when starting the re-ording process. You insert a blank row object into your
    // data source and return the object you want to save for later. This method is only called once.
    open func saveObjectAndInsertBlankRow(at indexPath: IndexPath) -> Any {
        let item = sections[indexPath]
        sections[indexPath] = DynamicTableModel(userInfo: [DynamicTableView.reorderTableViewDummyItemIdentifier: true])
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
