//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct SafeAreaLayoutGuideOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let top = Self(rawValue: 1 << 0)
    public static let bottom = Self(rawValue: 1 << 1)
    public static let leading = Self(rawValue: 1 << 2)
    public static let trailing = Self(rawValue: 1 << 3)

    public static let vertical: Self = [top, bottom]
    public static let horizontal: Self = [leading, trailing]

    public static let all: Self = [vertical, horizontal]
    public static let none: Self = []
}

extension SafeAreaLayoutGuideOptions {
    func topAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        contains(.top) ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
    }

    func bottomAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        contains(.bottom) ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
    }

    func leadingAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        contains(.leading) ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
    }

    func trailingAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        contains(.trailing) ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
    }
}
