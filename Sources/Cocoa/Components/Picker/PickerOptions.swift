//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A type to present list of items in a type safe manner.
public protocol PickerOptions: Equatable, CustomAnalyticsValueConvertible {
    var title: String { get }
    var subtitle: String? { get }
    var image: ImageRepresentable? { get }
}

extension PickerOptions {
    public var image: ImageRepresentable? {
        nil
    }

    public var subtitle: String? {
        nil
    }
}

/// A type to present list of items in a type safe manner.
public protocol PickerOptionsEnum: PickerOptions {
    static var allCases: [Self] { get }
}
