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

    public static let top = SafeAreaLayoutGuideOptions(rawValue: 1 << 0)
    public static let bottom = SafeAreaLayoutGuideOptions(rawValue: 1 << 1)
    public static let leading = SafeAreaLayoutGuideOptions(rawValue: 1 << 2)
    public static let trailing = SafeAreaLayoutGuideOptions(rawValue: 1 << 3)

    public static let vertical: SafeAreaLayoutGuideOptions = [top, bottom]
    public static let horizontal: SafeAreaLayoutGuideOptions = [leading, trailing]

    public static let all: SafeAreaLayoutGuideOptions = [vertical, horizontal]
    public static let none: SafeAreaLayoutGuideOptions = []
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
