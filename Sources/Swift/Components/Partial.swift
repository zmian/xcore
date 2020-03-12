//
// Partial.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// Credit: https://forums.swift.org/t/compositional-initialization/29535/22
@dynamicMemberLookup
struct Partial<Whole> {
    private var assignments: [PartialKeyPath<Whole>: (value: Any, update: (inout Whole) -> Void)] = [:]

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Whole, Value>) -> Value? {
        get { assignments[keyPath]?.value as? Value }
        set {
            guard let newValue = newValue else {
                assignments.removeValue(forKey: keyPath)
                return
            }
            assignments[keyPath] = (value: newValue, update: { whole in
                whole[keyPath: keyPath] = newValue
            })
        }
    }

    func applied(to initial: Whole) -> Whole {
        assignments.values.lazy
            .map { value, update in update }
            .reduce(into: initial) { whole, update in update(&whole) }
    }
}
