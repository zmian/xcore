//
// MulticastDelegate.swift
//
// Copyright © 2018 Xcore
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
