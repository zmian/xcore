//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct ElementPosition: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let primary = Self(rawValue: 1 << 0)
    public static let secondary = Self(rawValue: 1 << 1)
    public static let tertiary = Self(rawValue: 1 << 2)
    public static let quaternary = Self(rawValue: 1 << 3)
}

// MARK: - ButtonIdentifier

public enum ButtonIdentifierTag {}
public typealias ButtonIdentifier = Identifier<ButtonIdentifierTag>

extension ButtonIdentifier {
    public static var plain: Self { #function }
    public static var fill: Self { #function }
    public static var outline: Self { #function }
}

// MARK: - ButtonState

public enum ButtonState {
    case normal
    case pressed
    case disabled
}

// MARK: - ButtonProminence

public enum ButtonProminence {
    case fill
    case outline
}
