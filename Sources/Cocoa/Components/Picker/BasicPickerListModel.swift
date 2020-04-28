//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension PickerList {
    /// A convenience method to display a picker with list of items that conforms to
    /// `PickerOptions` protocol.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// enum CompassPoint: Int, CaseIterable, PickerOptionsEnum {
    ///     case north, south, east, west
    /// }
    ///
    /// PickerList.present(selected: CompassPoint.allCases.first) { (item: CompassPoint) -> Void in
    ///     print("selected item:" item)
    /// }
    /// ```
    @discardableResult
    public static func present<T: PickerOptionsEnum>(
        selected item: T? = nil,
        configure: ((PickerList) -> Void)? = nil,
        _ handler: @escaping (_ item: T) -> Void
    ) -> PickerList {
        let model = BasicPickerListModel(items: T.allCases, selected: item) { item in
            handler(item)
        }

        let picker = PickerList(model: model)
        configure?(picker)
        picker.present()
        return picker
    }

    /// A convenience method to display a picker with list of items that conforms to
    /// `PickerOptions` protocol.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// struct Menu: PickerOptions {
    ///     let name: String
    ///     let amount: Double
    /// }
    ///
    /// let items = [
    ///     Menu(name: "Caffè Latte", amount: 2.95),
    ///     Menu(name: "Cappuccino", amount: 3.45),
    ///     Menu(name: "Caffè Mocha", amount: 3.45)
    /// ]
    ///
    /// Picker.present(items, selected: items.first) { (item: Menu) -> Void in
    ///     print("selected item:" item)
    /// }
    /// ```
    @discardableResult
    public static func present<T: PickerOptions>(
        _ items: [T],
        selected item: T? = nil,
        configure: ((PickerList) -> Void)? = nil,
        _ handler: @escaping (_ item: T) -> Void
    ) -> PickerList {
        let model = BasicPickerListModel(items: items, selected: item) { item in
            handler(item)
        }

        let picker = PickerList(model: model)
        configure?(picker)
        picker.present()
        return picker
    }

    /// A convenience method to display a picker with list of items.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let items = ["Year", "Month", "Day"]
    /// PickerList.present(items, selected: items.first) { item in
    ///     print("selected item:" item)
    /// }
    /// ```
    @discardableResult
    public static func present(
        _ items: [String],
        selected item: String? = nil,
        _ handler: @escaping (_ item: String) -> Void
    ) -> PickerList {
        let model = BasicTextPickerListModel(items: items, selected: item) { item in
            handler(item)
        }

        let picker = PickerList(model: model)
        picker.present()
        return picker
    }

    /// A convenience method to display a picker with list of item.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let items = [
    ///     DynamicTableModel(title: "Year") { _ in }
    ///     DynamicTableModel(title: "Month") { _ in }
    ///     DynamicTableModel(title: "Day") { _ in }
    /// ]
    /// PickerList.present(items)
    /// ```
    @discardableResult
    public static func present(
        _ items: [DynamicTableModel],
        configure: PickerList.ConfigureBlock? = nil
    ) -> PickerList {
        let model = BasicItemPickerListModel(items: items, configure: configure)
        let picker = PickerList(model: model)
        picker.present()
        return picker
    }
}

// MARK: - BasicPickerListModel

private final class BasicPickerListModel<T: PickerOptions>: PickerListModel {
    private let rawItems: [T]
    private let selectedIndex: Int?
    private var selectionCallback: (T) -> Void

    init(items: [T], selected item: T? = nil, handler: @escaping (T) -> Void) {
        self.rawItems = items

        if let item = item, let index = items.firstIndex(of: item) {
            selectedIndex = index
        } else {
            selectedIndex = nil
        }

        selectionCallback = handler
    }

    private var checkmarkView: UIImageView {
        UIImageView(assetIdentifier: .checkmarkIcon).apply {
            $0.frame.size = 20
            $0.tintColor = .appleGreen
            $0.isContentModeAutomaticallyAdjusted = true
        }
    }

    lazy var items: [DynamicTableModel] = {
        rawItems.enumerated().map {
            DynamicTableModel(
                title: $0.element.title,
                subtitle: $0.element.subtitle,
                image: $0.element.image,
                accessory: $0.offset == selectedIndex ? .custom(checkmarkView) : .none
            ) { [weak self] indexPath, _ in
                guard
                    let strongSelf = self,
                    let item = strongSelf.rawItems.at(indexPath.item)
                else {
                    return
                }

                strongSelf.selectionCallback(item)
                DrawerScreen.dismiss()
            }
        }
    }()
}

// MARK: - BasicTextPickerListModel

private final class BasicTextPickerListModel: PickerListModel {
    private let rawItems: [String]
    private let selectedIndex: Int?
    private var selectionCallback: (String) -> Void

    init(items: [String], selected item: String? = nil, handler: @escaping (String) -> Void) {
        self.rawItems = items

        if let item = item, let index = items.firstIndex(of: item) {
            selectedIndex = index
        } else {
            selectedIndex = nil
        }

        selectionCallback = handler
    }

    private var checkmarkView: UIImageView {
        UIImageView(assetIdentifier: .checkmarkIcon).apply {
            $0.frame.size = 20
            $0.tintColor = .appleGreen
            $0.isContentModeAutomaticallyAdjusted = true
        }
    }

    lazy var items: [DynamicTableModel] = {
        rawItems.enumerated().map {
            DynamicTableModel(
                title: $0.element,
                accessory: $0.offset == selectedIndex ? .custom(checkmarkView) : .none
            ) { [weak self] indexPath, _ in
                guard
                    let strongSelf = self,
                    let item = strongSelf.rawItems.at(indexPath.item)
                else {
                    return
                }

                strongSelf.selectionCallback(item)
                DrawerScreen.dismiss()
            }
        }
    }()

    func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) {
        cell.titleLabel.textAlignment = .center
    }
}

// MARK: - BasicItemPickerListModel

private final class BasicItemPickerListModel: PickerListModel {
    private let _configure: PickerList.ConfigureBlock?
    let items: [DynamicTableModel]

    init(items: [DynamicTableModel], configure: PickerList.ConfigureBlock? = nil) {
        self.items = items
        self._configure = configure
    }

    func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) {
        if item.isTextOnly {
            cell.titleLabel.textAlignment = .center
        }

        _configure?(indexPath, cell, item)
    }
}

extension PickerList {
    public typealias ConfigureBlock = (
        _ indexPath: IndexPath,
        _ cell: DynamicTableViewCell,
        _ item: DynamicTableModel
    ) -> Void
}
