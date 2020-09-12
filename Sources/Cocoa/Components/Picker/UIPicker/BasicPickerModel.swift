//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Picker {
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
    /// Picker.present(selected: CompassPoint.allCases.first) { (item: CompassPoint) -> Void in
    ///     print("selected item:" item)
    /// }
    /// ```
    @discardableResult
    public static func present<T: PickerOptionsEnum>(
        selected item: T? = nil,
        configure: ((Picker) -> Void)? = nil,
        didSelect: @escaping (_ item: T) -> Void
    ) -> Picker {
        let model = BasicPickerModel(items: T.allCases, selected: item) { item in
            didSelect(item)
        }

        let picker = Picker(model: model)
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
        configure: ((Picker) -> Void)? = nil,
        didSelect: @escaping (_ item: T) -> Void
    ) -> Picker {
        let model = BasicPickerModel(items: items, selected: item) { item in
            didSelect(item)
        }

        let picker = Picker(model: model)
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
    /// Picker.present(items, selected: items.first) { item in
    ///     print("selected item:" item)
    /// }
    /// ```
    @discardableResult
    public static func present(
        _ items: [String],
        selected item: String? = nil,
        configure: ((Picker) -> Void)? = nil,
        didSelect: @escaping (_ item: String) -> Void
    ) -> Picker {
        let model = BasicTextPickerModel(items: items, selected: item) { item in
            didSelect(item)
        }

        let picker = Picker(model: model)
        configure?(picker)
        picker.present()
        return picker
    }

    public static func present(
        initialValue date: Date? = nil,
        configuration: Configuration<UIDatePicker>? = nil,
        _ callback: @escaping (Date?) -> Void
    ) {
        DatePicker.present(initialValue: date, configuration: configuration, callback)
    }
}

// MARK: - BasicPickerModel

private final class BasicPickerModel<T: PickerOptions>: PickerModel {
    // Allow us to reload items where `T: PickerOptionsEnum`. See
    // `pickerReloadAllComponents()` for usage.
    private let itemsProvider: () -> [T]
    private var items: [T]
    private var selectedItem: T
    private var selectionCallback: (T) -> Void

    init(items: @autoclosure @escaping () -> [T], selected item: T? = nil, didSelect: @escaping (T) -> Void) {
        self.itemsProvider = items
        self.items = items()

        if let item = item, let index = self.items.firstIndex(of: item) {
            selectedItem = self.items[index]
        } else {
            selectedItem = self.items[0]
        }

        selectionCallback = didSelect
    }

    private func setSelectedItem(_ item: T? = nil) {
        guard !items.isEmpty else {
            return
        }

        if let item = item, let index = items.firstIndex(of: item) {
            selectedItem = items[index]
        } else {
            selectedItem = items.first!
        }
    }

    func selectedElement(at component: Int) -> Int {
        items.firstIndex(of: selectedItem) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        items.count
    }

    func element(at component: Int, row: Int) -> Picker.RowModel {
        let item = items[row]
        return .init(image: item.image, title: item.title, subtitle: item.subtitle)
    }

    func pickerDidTapDone() {
        selectionCallback(selectedItem)
    }

    func pickerDidSelectValue(value: Int, at component: Int) {
        selectedItem = items[value]
    }

    func pickerDidDismiss() { }

    func pickerReloadAllComponents() {
        items = itemsProvider()
        setSelectedItem(selectedItem)
    }
}

// MARK: - BasicTextPickerModel

private final class BasicTextPickerModel: PickerModel {
    private let items: [String]
    private var selectedOption: String
    private var selectionCallback: (String) -> Void

    init(items: [String], selected item: String? = nil, didSelect: @escaping (String) -> Void) {
        self.items = items

        if let item = item, let index = items.firstIndex(of: item) {
            selectedOption = items[index]
        } else {
            selectedOption = items.first!
        }

        selectionCallback = didSelect
    }

    func selectedElement(at component: Int) -> Int {
        items.firstIndex(of: selectedOption) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        items.count
    }

    func element(at component: Int, row: Int) -> Picker.RowModel {
        .init(title: items[row])
    }

    func pickerDidTapDone() {
        selectionCallback(selectedOption)
    }

    func pickerDidSelectValue(value: Int, at component: Int) {
        selectedOption = items[value]
    }

    func pickerDidDismiss() { }
}
