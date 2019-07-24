//
// PickerModel.swift
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

public protocol PickerModel {
    func numberOfComponents() -> Int
    func numberOfElements(at component: Int) -> Int
    func element(at component: Int, row: Int) -> Picker.RowModel
    func selectedElement(at component: Int) -> Int
    func pickerDidDismiss()
    func pickerDidTapDone()
    func pickerDidSelectValue(value: Int, at component: Int)
    func pickerReloadComponents(on componentChanged: Int) -> [Int]
    func pickerReloadAllComponents()
    func pickerDidCancel()
}

extension PickerModel {
    public func numberOfComponents() -> Int {
        return 1
    }

    public func numberOfElements(at component: Int) -> Int {
        return 1
    }

    public func element(at component: Int, row: Int) -> Picker.RowModel {
        return .init(title: "Empty Element")
    }

    public func selectedElement(at component: Int) -> Int {
        return 0
    }

    public func pickerDidDismiss() {
    }

    public func pickerDidTapDone() {
    }

    public func pickerDidSelectValue(value: Int, at component: Int) {
    }

    public func pickerReloadComponents(on componentChanged: Int) -> [Int] {
        return []
    }

    public func pickerReloadAllComponents() {
    }

    public func pickerDidCancel() {
    }
}
