//
// SnapKit+Extensions.swift
//
// Copyright © 2017 Xcore
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

#if canImport(SnapKit)
// swiftlint:disable:next import_snapkit
import SnapKit

extension Array where Element: UIView {
    public var snp: [SnapKit.ConstraintViewDSL] {
        return map { $0.snp }
    }
}

extension Array where Element == SnapKit.ConstraintViewDSL {
    public func prepareConstraints(_ closure: (SnapKit.ConstraintMaker) -> Void) -> [[SnapKit.Constraint]] {
        return map { $0.prepareConstraints(closure) }
    }

    public func makeConstraints(_ closure: (SnapKit.ConstraintMaker) -> Void) {
        forEach { $0.makeConstraints(closure) }
    }

    public func remakeConstraints(_ closure: (SnapKit.ConstraintMaker) -> Void) {
        forEach { $0.remakeConstraints(closure) }
    }

    public func updateConstraints(_ closure: (SnapKit.ConstraintMaker) -> Void) {
        forEach { $0.updateConstraints(closure) }
    }

    public func removeConstraints() {
        forEach { $0.removeConstraints() }
    }
}

extension ConstraintPriority {
    public init(_ value: UILayoutPriority) {
        self.init(value.rawValue)
    }
}

extension ConstraintMakerPriortizable {
    @discardableResult
    public func priority(_ amount: UILayoutPriority) -> ConstraintMakerFinalizable {
        return priority(amount.rawValue)
    }
}

extension Constraint {
    @discardableResult
    public func update(priority: UILayoutPriority) -> Constraint {
        return update(priority: priority.rawValue)
    }
}

extension LayoutConstraintItem {
    fileprivate var targetSuperview: ConstraintView? {
        if let view = self as? ConstraintView {
            return view.superview
        }

        if let guide = self as? ConstraintLayoutGuide {
            return guide.owningView
        }

        return nil
    }
}

extension ConstraintMakerRelatable {
    @discardableResult
    public func equalToSuperviewSafeArea(_ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        guard let safeAreaLayoutGuide = safeAreaLayoutGuide(file, line) else {
            return equalToSuperview(file, line)
        }
        return equalTo(safeAreaLayoutGuide)
    }

    @discardableResult
    public func greaterThanOrEqualToSuperviewSafeArea(_ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        guard let safeAreaLayoutGuide = safeAreaLayoutGuide(file, line) else {
            return greaterThanOrEqualToSuperview(file, line: line)
        }
        return greaterThanOrEqualTo(safeAreaLayoutGuide)
    }

    @discardableResult
    public func lessThanOrEqualToSuperviewSafeArea(_ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        guard let safeAreaLayoutGuide = safeAreaLayoutGuide(file, line) else {
            return lessThanOrEqualToSuperview(file, line)
        }
        return lessThanOrEqualTo(safeAreaLayoutGuide)
    }

    private func safeAreaLayoutGuide(_ file: String = #file, _ line: UInt = #line) -> UILayoutGuide? {
        var mirror = Mirror(reflecting: self)

        if let superclassMirror = mirror.superclassMirror {
            mirror = superclassMirror
        }

        guard mirror.subjectType == SnapKit.ConstraintMakerRelatable.self else {
            #if DEBUG
                fatalError("SnapKit class hierarchy changed. Please update the following code to adjust accordingly.")
            #else
                return nil
            #endif
        }

        guard
            let description = mirror.children.first(where: { $0.label == "description" })?.value,
            let item = Mirror(reflecting: description).children.first(where: { $0.label == "item" })?.value as? LayoutConstraintItem,
            let targetSuperview = item.targetSuperview
        else {
            #if DEBUG
                fatalError("SnapKit.ConstraintMakerRelatable layout changed. Please update the following code to adjust accordingly.")
            #else
                return nil
            #endif
        }

        return targetSuperview.safeAreaLayoutGuide
    }
}

extension ConstraintMakerRelatable {
    @discardableResult
    public func equalTo(_ other: CGFloat, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        let internalEqualTo: (_ other: ConstraintRelatableTarget, _ file: String, _ line: UInt) -> ConstraintMakerEditable = equalTo(_:_:_:)
        return internalEqualTo(other, file, line)
    }

    @discardableResult
    public func lessThanOrEqualTo(_ other: CGFloat, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        let internalLessThanOrEqualTo: (_ other: ConstraintRelatableTarget, _ file: String, _ line: UInt) -> ConstraintMakerEditable = lessThanOrEqualTo(_:_:_:)
        return internalLessThanOrEqualTo(other, file, line)
    }

    @discardableResult
    public func greaterThanOrEqualTo(_ other: CGFloat, _ file: String = #file, line: UInt = #line) -> ConstraintMakerEditable {
        let internalGreaterThanOrEqualTo: (_ other: ConstraintRelatableTarget, _ file: String, _ line: UInt) -> ConstraintMakerEditable = greaterThanOrEqualTo(_:_:line:)
        return internalGreaterThanOrEqualTo(other, file, line)
    }
}

// MARK: ConstraintPriority

extension ConstraintPriority {
    public static func +(lhs: SnapKit.ConstraintPriority, rhs: Float) -> ConstraintPriority {
        return ConstraintPriority(lhs.value + rhs)
    }

    public static func -(lhs: SnapKit.ConstraintPriority, rhs: Float) -> ConstraintPriority {
        return ConstraintPriority(lhs.value - rhs)
    }
}

// MARK: Convenience API to allow `.minimumPadding or .defaultPadding`.

extension ConstraintMakerEditable {
    @discardableResult
    public func multipliedBy(_ amount: CGFloat) -> ConstraintMakerEditable {
        let internalMultipliedBy: (_ amount: ConstraintMultiplierTarget) -> ConstraintMakerEditable = multipliedBy(_:)
        return internalMultipliedBy(amount)
    }

    @discardableResult
    public func dividedBy(_ amount: CGFloat) -> ConstraintMakerEditable {
        let internalDividedBy: (_ amount: ConstraintMultiplierTarget) -> ConstraintMakerEditable = dividedBy(_:)
        return internalDividedBy(amount)
    }

    @discardableResult
    public func offset(_ amount: CGFloat) -> ConstraintMakerEditable {
        let internalOffset: (_ amount: ConstraintOffsetTarget) -> ConstraintMakerEditable = offset(_:)
        return internalOffset(amount)
    }

    @discardableResult
    public func inset(_ amount: CGFloat) -> ConstraintMakerEditable {
        let internalInset: (_ amount: ConstraintInsetTarget) -> ConstraintMakerEditable = inset(_:)
        return internalInset(amount)
    }
}

extension Constraint {
    @discardableResult
    public func update(offset: CGFloat) -> Constraint {
        let internalUpdate: (_ offset: ConstraintOffsetTarget) -> Constraint = update(offset:)
        return internalUpdate(offset)
    }

    @discardableResult
    public func update(inset: CGFloat) -> Constraint {
        let internalUpdate: (_ inset: ConstraintInsetTarget) -> Constraint = update(inset:)
        return internalUpdate(inset)
    }
}
#endif
