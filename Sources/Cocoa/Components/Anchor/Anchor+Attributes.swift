//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Anchor {
    struct Attributes: OptionSet {
        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let top = Attributes(rawValue: 1 << 0)
        static let bottom = Attributes(rawValue: 1 << 1)

        static let leading = Attributes(rawValue: 1 << 2)
        static let trailing = Attributes(rawValue: 1 << 3)

        static let width = Attributes(rawValue: 1 << 4)
        static let height = Attributes(rawValue: 1 << 5)

        static let centerX = Attributes(rawValue: 1 << 6)
        static let centerY = Attributes(rawValue: 1 << 7)

        static let firstBaseline = Attributes(rawValue: 1 << 8)
        static let lastBaseline = Attributes(rawValue: 1 << 9)

        static let vertical: Attributes = [top, bottom]
        static let horizontal: Attributes = [leading, trailing]
        static let edges: Attributes = [vertical, horizontal]
        static let size: Attributes = [width, height]
        static let center: Attributes = [centerX, centerY]

        static func related(to attribute: Attributes) -> [Attributes] {
            switch attribute {
                case .top:
                    return [.top, .bottom, .centerY, .firstBaseline, .lastBaseline]
                case .bottom:
                    return [.bottom, .top, .centerY, .firstBaseline, .lastBaseline]
                case .centerY:
                    return [centerY, .top, .bottom, .firstBaseline, .lastBaseline]
                case .firstBaseline:
                    return [.firstBaseline, .lastBaseline, .top, .bottom, .centerY]
                case .lastBaseline:
                    return [.lastBaseline, .firstBaseline, .top, .bottom, .centerY]

                case .centerX:
                    return [centerX, .leading, .trailing]
                case .leading:
                    return [.leading, .trailing, .centerX]
                case .trailing:
                    return [.trailing, .leading, .centerX]

                case .width:
                    return [.width, .height]
                case .height:
                    return [.height, .width]

                default:
                    fatalError("Detected unknown attribute: \(attribute).")
            }
        }
    }
}

extension Anchor.Attributes {
    func yAxisAnchor(
        _ view: UIView,
        safeAreaLayoutGuideOptions: SafeAreaLayoutGuideOptions,
        preferred: [Anchor.Attributes],
        file: StaticString = #file,
        line: UInt = #line
    ) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        func inner(_ attribute: Anchor.Attributes) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
            switch attribute {
                case .top:
                    return safeAreaLayoutGuideOptions.topAnchor(view)
                case .bottom:
                    return safeAreaLayoutGuideOptions.bottomAnchor(view)
                case .centerY:
                    return view.centerYAnchor
                case .firstBaseline:
                    return view.firstBaselineAnchor
                case .lastBaseline:
                    return view.lastBaselineAnchor
                default:
                    fatalError("Unable to find appropriate Y-Axis anchor.", file: file, line: line)
            }
        }

        for attr in preferred where contains(attr) {
            return inner(attr)
        }

        return inner(self)
    }

    func xAxisAnchor(
        _ view: UIView,
        safeAreaLayoutGuideOptions: SafeAreaLayoutGuideOptions,
        preferred: [Anchor.Attributes],
        file: StaticString = #file,
        line: UInt = #line
    ) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        func inner(_ attribute: Anchor.Attributes) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
            switch attribute {
                case .leading:
                    return safeAreaLayoutGuideOptions.leadingAnchor(view)
                case .trailing:
                    return safeAreaLayoutGuideOptions.trailingAnchor(view)
                case .centerX:
                    return view.centerXAnchor
                default:
                    fatalError("Unable to find appropriate X-Axis anchor.", file: file, line: line)
            }
        }

        for attr in preferred where contains(attr) {
            return inner(attr)
        }

        return inner(self)
    }

    func dimensionAnchor(
        _ view: UIView,
        preferred: [Anchor.Attributes],
        file: StaticString = #file,
        line: UInt = #line
    ) -> NSLayoutAnchor<NSLayoutDimension> {
        func inner(_ attribute: Anchor.Attributes) -> NSLayoutAnchor<NSLayoutDimension> {
            switch self {
                case .width:
                    return view.widthAnchor
                case .height:
                    return view.heightAnchor
                default:
                    fatalError("Unable to find appropriate dimension anchor.", file: file, line: line)
            }
        }

        for attr in preferred where contains(attr) {
            return inner(attr)
        }

        return inner(self)
    }
}
