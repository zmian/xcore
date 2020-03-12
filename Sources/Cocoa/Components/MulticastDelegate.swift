//
// MulticastDelegate.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public class MulticastDelegate<T: NSObject>: NSObject {
    private var delegates: [Weak<T>] = []

    public override init() {
        super.init()
    }

    public func add(_ delegate: T) {
        flatten()
        delegates.append(Weak(delegate))
    }

    public func remove(_ delegate: T) {
        flatten()

        guard let index = delegates.firstIndex(where: { $0 == delegate }) else {
            return
        }

        delegates.remove(at: index)
    }

    /// Removes all elements where the `value` is deallocated.
    private func flatten() {
        for (index, element) in delegates.enumerated() where element.value == nil {
            delegates.remove(at: index)
        }
    }
}

extension MulticastDelegate: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        flatten()

        var iterator = delegates.makeIterator()

        return AnyIterator {
            while let next = iterator.next() {
                if let delegate = next.value {
                    return delegate
                }
            }

            return nil
        }
    }
}
