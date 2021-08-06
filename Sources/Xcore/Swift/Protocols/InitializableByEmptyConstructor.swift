//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

public protocol InitializableByEmptyConstructor {
    init()
}

// MARK: - InitializableBySequence

public protocol InitializableBySequence: Sequence {
    @inlinable
    init<S>(_ elements: S) where S: Sequence, Element == S.Element
}

extension Array: InitializableBySequence {}
extension Set: InitializableBySequence {}
