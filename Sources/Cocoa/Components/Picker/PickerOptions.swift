//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A type to present list of options in a type safe manner.
public protocol PickerOptions: CustomStringConvertible, Equatable {
    static var allCases: [Self] { get }
    static var title: String? { get }
    static var message: String? { get }
    var image: ImageRepresentable? { get }
}

extension PickerOptions {
    public static var title: String? {
        nil
    }

    public static var message: String? {
        nil
    }

    public var image: ImageRepresentable? {
        nil
    }
}
