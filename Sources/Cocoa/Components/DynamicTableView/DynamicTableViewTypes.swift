//
// DynamicTableViewTypes.swift
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

public enum ListAccessoryType {
    case none
    case disclosureIndicator
    case text(String)
    case custom(UIView)
    case toggle(isOn: Bool, callback: ((_ sender: UISwitch) -> Void)?)
    case checkbox(isSelected: Bool, callback: ((_ sender: UIButton) -> Void)?)
}

public struct DynamicTableModel {
    public var title: StringRepresentable?
    public var subtitle: StringRepresentable?
    public var image: ImageRepresentable?
    public var accessory: ListAccessoryType = .none
    public var userInfo: [AnyHashable: Any] = [:]
    public var handler: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?

    public init(
        title: StringRepresentable? = nil,
        subtitle: StringRepresentable? = nil,
        image: ImageRepresentable? = nil,
        accessory: ListAccessoryType = .none,
        userInfo: [AnyHashable: Any] = [:],
        handler: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.accessory = accessory
        self.userInfo = userInfo
        self.handler = handler
    }

    var isTextOnly: Bool {
        if image == nil, case.none = accessory {
            return true
        }

        return false
    }
}
