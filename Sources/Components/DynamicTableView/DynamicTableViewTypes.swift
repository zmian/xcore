//
// DynamicTableViewTypes.swift
//
// Copyright © 2016 Zeeshan Mian
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
import BEMCheckBox

public enum DynamicTableAccessoryType {
    case None
    case DisclosureIndicator
    case Text(String)
    case Custom(UIView)
    case Switch(isOn: Bool, callback: (sender: UISwitch) -> Void)
    case Checkbox(isOn: Bool, callback: (sender: BEMCheckBox) -> Void)
}

public struct DynamicTableCellOptions: OptionSetType {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }

    public static let Movable                      = DynamicTableCellOptions(rawValue: 1)
    public static let Deletable                    = DynamicTableCellOptions(rawValue: 2)
    public static let All: DynamicTableCellOptions = [Movable, Deletable]
}

public struct DynamicTableModel {
    public var title: StringRepresentable?
    public var subtitle: StringRepresentable?
    public var image: ImageRepresentable?
    public var accessory: DynamicTableAccessoryType
    public var userInfo: [String: Any]

    public init(title: StringRepresentable? = nil, subtitle: StringRepresentable? = nil, image: ImageRepresentable? = nil, accessory: DynamicTableAccessoryType = .None, userInfo: [String: Any] = [:]) {
        self.title     = title
        self.subtitle  = subtitle
        self.image     = image
        self.accessory = accessory
        self.userInfo  = userInfo
    }
}
