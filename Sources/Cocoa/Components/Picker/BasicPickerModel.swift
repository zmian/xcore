//
// BasicPickerModel.swift
//
// Copyright © 2015 Xcore
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

import Foundation

extension Picker {
    /// A convenience method to display a picker with list of options
    /// that conforms to `OptionsRepresentable` protocol.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// enum CompassPoint: Int, CaseIterable, OptionsRepresentable {
    ///     case north, south, east, west
    /// }
    ///
    /// Picker.present(selected: CompassPoint.allCases.first) { (option: CompassPoint) -> Void in
    ///     print("selected option:" option)
    /// }
    /// ```
    @discardableResult
    public static func present<T: OptionsRepresentable>(
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
}

private final class BasicPickerModel<T: OptionsRepresentable>: PickerModel {
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
        return options.firstIndex(of: selectedOption) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        return options.count
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
        return options.firstIndex(of: selectedOption) ?? 0
    }

    func numberOfElements(at component: Int) -> Int {
        return options.count
    }

    func element(at component: Int, row: Int) -> Picker.RowModel {
        return .init(title: options[row])
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
