//
// Picker+Content.swift
//
// Copyright © 2019 Xcore
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

extension Picker {
    final class Content: NSObject, DrawerScreen.Content {
        private static let viewableItemsCount = 5

        private let model: PickerModel
        private let toolbar = InputToolbar().apply {
            $0.backgroundColor = .clear
        }
        private lazy var pickerView = UIPickerView().apply {
            $0.delegate = self
            $0.dataSource = self
            $0.showsSelectionIndicator = true
        }

        private lazy var stackView = UIStackView(arrangedSubviews: [
            toolbar,
            pickerView
        ]).apply {
            $0.axis = .vertical
        }

        var drawerContentView: UIView {
            return stackView
        }

        init(model: PickerModel) {
            self.model = model
            super.init()
            commonInit()
        }

        private func commonInit() {
            for i in 0..<model.numberOfComponents() {
                let element = model.selectedElement(at: i)
                pickerView.selectRow(element, inComponent: i, animated: false)
            }

            toolbar.didTapDone { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.updateSelectedRows()
                strongSelf.model.pickerDidTapDone()
                strongSelf.dismiss()
            }

            toolbar.didTapCancel { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.model.pickerDidCancel()
                strongSelf.dismiss()
            }
        }

        private func updateSelectedRows() {
            // iterates through all the slider's components and getting the most updated value for each component
            for i in 0..<pickerView.numberOfComponents {
                // takes into account potential changes other component's datasources due to the current component's value change
                model.pickerReloadComponents(on: i).forEach {
                    pickerView.reloadComponent($0)
                    // makes sure to preserve any selected value in reloaded components, if any. Otherwise, set to selected to 0 (top)
                    let selectedRow = max(0, pickerView.selectedRow(inComponent: $0))
                    pickerView.selectRow(selectedRow, inComponent: $0, animated: false)
                    model.pickerDidSelectValue(value: selectedRow, at: $0)
                }
                model.pickerDidSelectValue(value: pickerView.selectedRow(inComponent: i), at: i)
            }
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension Picker.Content: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.numberOfElements(at: component)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return model.numberOfComponents()
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Picker.RowView.height
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowView: Picker.RowView
        if let view = view as? Picker.RowView {
            rowView = view
        } else {
            rowView = Picker.RowView()
        }
        rowView.configure(model.element(at: component, row: row))
        return rowView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.pickerDidSelectValue(value: row, at: component)

        model.pickerReloadComponents(on: component).forEach {
            pickerView.reloadComponent($0)
            pickerView.selectRow(0, inComponent: $0, animated: true)
            model.pickerDidSelectValue(value: 0, at: $0)
        }
    }
}

// MARK: - API

extension Picker.Content {
    func present() {
        DrawerScreen.present(self)
    }

    func dismiss() {
        DrawerScreen.dismiss()
    }

    func didTapOtherButton(_ callback: @escaping () -> Void) {
        toolbar.didTapOther { [weak self] in
            guard let strongSelf = self else { return }
            callback()
            strongSelf.dismiss()
        }
    }

    /// Reloads all components of the picker view.
    ///
    /// Calling this method causes the picker view to query the delegate for new
    /// data for all components.
    func reloadData() {
        model.pickerReloadAllComponents()

        guard model.numberOfElements(at: 0) > 0 else {
            // Nothing to display. Dismiss the picker view.
            dismiss()
            return
        }

        pickerView.reloadAllComponents()
    }

    func setTitle(_ title: StringRepresentable?) {
        toolbar.title = title
    }
}
