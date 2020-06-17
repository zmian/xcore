//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
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
    public var accessory: ListAccessoryType
    public var isSelected: Bool
    public var userInfo: [AnyHashable: Any]
    public var didSelect: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)?

    public init(
        title: StringRepresentable? = nil,
        subtitle: StringRepresentable? = nil,
        image: ImageRepresentable? = nil,
        accessory: ListAccessoryType = .none,
        isSelected: Bool = false,
        userInfo: [AnyHashable: Any] = [:],
        didSelect: ((_ indexPath: IndexPath, _ item: DynamicTableModel) -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.accessory = accessory
        self.isSelected = isSelected
        self.userInfo = userInfo
        self.didSelect = didSelect
    }

    var isTextOnly: Bool {
        if image == nil, case.none = accessory {
            return true
        }

        return false
    }
}
