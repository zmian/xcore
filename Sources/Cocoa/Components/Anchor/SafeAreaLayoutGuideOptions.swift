//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

struct SafeAreaLayoutGuideOptions: OptionSet {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static let top = Self(rawValue: 1 << 0)
    static let bottom = Self(rawValue: 1 << 1)
    static let leading = Self(rawValue: 1 << 2)
    static let trailing = Self(rawValue: 1 << 3)

    static let vertical: Self = [top, bottom]
    static let horizontal: Self = [leading, trailing]

    static let all: Self = [vertical, horizontal]
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
