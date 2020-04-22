//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Picker {
    /// A convenience method to display a picker with list of options
    /// that conforms to `PickerOptions` protocol.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// enum CompassPoint: Int, CaseIterable, PickerOptions {
    ///     case north, south, east, west
    /// }
    ///
    /// Picker.present(selected: CompassPoint.allCases.first) { (option: CompassPoint) -> Void in
    ///     print("selected option:" option)
    /// }
    /// ```
    @discardableResult
    public static func present<T: PickerOptions>(
        selected option: T? = nil,
        configure: ((Picker) -> Void)? = nil,
        _ handler: @escaping (_ option: T) -> Void
    ) -> Picker {
        let model = BasicPickerModel(selected: option) { option in
            handler(option)
        }

        let picker = Picker(model: model)
        configure?(picker)
        picker.present()
        return picker
    }

    /// A convenience method to display a picker with list of options.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let options = ["Year", "Month", "Day"]
    /// Picker.present(options: options, selected: options.first) { option in
    ///     print("selected option:" option)
    /// }
    /// ```
    @discardableResult
    public static func present(
        options: [String],
        selected option: String? = nil,
        _ handler: @escaping (_ option: String) -> Void
    ) -> Picker {
        let model = BasicTextPickerModel(options: options, selected: option) { option in
            handler(option)
        }

        let picker = Picker(model: model)
        picker.present()
        return picker
    }

    public static func present(
        initialValue date: Date? = nil,
        configuration: Configuration<UIDatePicker>? = nil,
        _ callback: @escaping (Date?) -> Void
    ) {
        DatePicker.present(callback)
    }
}

// MARK: - BasicPickerModel

private final class BasicPickerModel<T: PickerOptions>: PickerModel {
    private var options: [T] = T.allCases
    private var selectedOption: T
    private var selectionCallback: (T) -> Void

    init(selected option: T? = nil, handler: @escaping (T) -> Void) {
        let allCases = T.allCases

        if let option = option, let index = allCases.firstIndex(of: option) {
            selectedOption = allCases[index]
        } else {
            selectedOption = T.allCases.first!
        }

        selectionCallback = handler
    }

    private func setSelectedOption(_ option: T? = nil) {
        let allCases = T.allCases

        guard !allCases.isEmpty else {
            return
        }

        if let option = option, let index = allCases.firstIndex(of: option) {
            selectedOption = allCases[index]
        } else {
            selectedOption = T.allCases.first!
        }
    }

    func selectedElement(at component: Int) -> Int {
        options.firstIndex(of: selectedOption) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        options.count
    }

    func element(at component: Int, row: Int) -> Picker.RowModel {
        let option = options[row]
        return .init(image: option.image, title: option.description)
    }

    func pickerDidTapDone() {
        selectionCallback(selectedOption)
    }

    func pickerDidSelectValue(value: Int, at component: Int) {
        selectedOption = options[value]
    }

    func pickerDidDismiss() {
    }

    func pickerReloadAllComponents() {
        options = T.allCases
        setSelectedOption(selectedOption)
    }
}

// MARK: - BasicTextPickerModel

private final class BasicTextPickerModel: PickerModel {
    private let options: [String]
    private var selectedOption: String
    private var selectionCallback: (String) -> Void

    init(options: [String], selected option: String? = nil, handler: @escaping (String) -> Void) {
        self.options = options

        if let option = option, let index = options.firstIndex(of: option) {
            selectedOption = options[index]
        } else {
            selectedOption = options.first!
        }

        selectionCallback = handler
    }

    func selectedElement(at component: Int) -> Int {
        options.firstIndex(of: selectedOption) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        options.count
    }

    func element(at component: Int, row: Int) -> Picker.RowModel {
        .init(title: options[row])
    }

    func pickerDidTapDone() {
        selectionCallback(selectedOption)
    }

    func pickerDidSelectValue(value: Int, at component: Int) {
        selectedOption = options[value]
    }

    func pickerDidDismiss() {
    }
}
