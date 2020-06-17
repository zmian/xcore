//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
        1
    }

    public func numberOfElements(at component: Int) -> Int {
        1
    }

    public func element(at component: Int, row: Int) -> Picker.RowModel {
        .init(title: "-")
    }

    public func selectedElement(at component: Int) -> Int {
        0
    }

    public func pickerDidDismiss() {
    }

    public func pickerDidTapDone() {
    }

    public func pickerDidSelectValue(value: Int, at component: Int) {
    }

    public func pickerReloadComponents(on componentChanged: Int) -> [Int] {
        []
    }

    public func pickerReloadAllComponents() {
    }

    public func pickerDidCancel() {
    }
}
