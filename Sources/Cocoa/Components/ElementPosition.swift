//
// ElementPosition.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct ElementPosition: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let primary = ElementPosition(rawValue: 1 << 0)
    public static let secondary = ElementPosition(rawValue: 1 << 1)
    public static let tertiary = ElementPosition(rawValue: 1 << 2)
}
