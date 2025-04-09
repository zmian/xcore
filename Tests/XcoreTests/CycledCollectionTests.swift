//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CycledCollectionTests {
    @Test("Cycling non-empty collection")
    func cyclingNonEmpty() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled[0] == 1)
        #expect(cycled[1] == 2)
        #expect(cycled[2] == 3)
        #expect(cycled[3] == 1)
        #expect(cycled[4] == 2)
        #expect(cycled[5] == 3)
    }

    @Test("Empty collection yields no elements")
    func emptyCollection() {
        let empty: [Int] = []
        let cycled = empty.cycled()

        var iterator = cycled.makeIterator()
        #expect(iterator.next() == nil)
    }

    @Test("Negative indices work correctly")
    func negativeIndices() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled[-1] == 3)
        #expect(cycled[-2] == 2)
        #expect(cycled[-3] == 1)
        #expect(cycled[-4] == 3)
    }

    @Test("Cycling already cycled collection avoids double nesting")
    func doubleCycling() {
        let numbers = [1, 2, 3]
        let cycledOnce = numbers.cycled()
        let cycledTwice = cycledOnce.cycled()

        #expect(cycledTwice[0] == 1)
        #expect(cycledTwice[5] == 3)
        #expect(cycledTwice[-1] == 3)

        #expect(type(of: cycledTwice) == type(of: cycledOnce))
        #expect(type(of: cycledTwice) == CycledCollection<[Int]>.self)
    }

    // MARK: - Sequence Conformance

    @Test("Iterator cycles indefinitely")
    func iterator() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()
        var iterator = cycled.makeIterator()

        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == 3)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
    }

    // MARK: - Collection Conformance

    @Test("Start and end indices")
    func collectionIndices() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled.startIndex == .position(0))
        #expect(cycled.endIndex == .infinity)
    }

    @Test("Index after advances correctly")
    func indexAfter() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled.index(after: .position(0)) == .position(1))
        #expect(cycled.index(after: .position(5)) == .position(6))
        #expect(cycled.index(after: .infinity) == .infinity)
    }

    @Test("Empty collection index after")
    func emptyIndexAfter() {
        let empty: [Int] = []
        let cycled = empty.cycled()

        #expect(cycled.index(after: .position(0)) == .infinity)
        #expect(cycled.index(after: .infinity) == .infinity)
    }

    // MARK: - Bidirectional Collection Conformance

    @Test("Index before works correctly")
    func indexBefore() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled.index(before: .position(1)) == .position(0))
        #expect(cycled.index(before: .position(0)) == .position(-1))
        #expect(cycled.index(before: .infinity) == .position(Int.max))
    }

    @Test("Empty collection index before")
    func emptyIndexBefore() {
        let empty: [Int] = []
        let cycled = empty.cycled()

        #expect(cycled.index(before: .position(1)) == .infinity)
        #expect(cycled.index(before: .infinity) == .infinity)
    }

    // MARK: - Random Access Collection Conformance

    typealias BaseIndex = CycledCollection<[Int]>.Index
    @Test("Index offset by works correctly", arguments: [
        (start: BaseIndex.position(0), distance: 5),
        (start: BaseIndex.position(10), distance: -3),
        (start: BaseIndex.infinity, distance: -2)
    ])
    func indexOffsetBy(startIndex: BaseIndex, distance: Int) {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        let result = cycled.index(startIndex, offsetBy: distance)

        switch (startIndex, distance) {
            case let (.position(pos), _):
                #expect(result == .position(pos + distance))
            case let (.infinity, d) where d < 0:
                #expect(result == .position(Int.max + d))
            case (.infinity, _):
                #expect(result == .infinity)
        }
    }

    @Test("Distance calculation")
    func distance() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()

        #expect(cycled.distance(from: .position(0), to: .position(5)) == 5)
        #expect(cycled.distance(from: .position(5), to: .position(0)) == -5)
        #expect(cycled.distance(from: .position(0), to: .infinity) == Int.max)
        #expect(cycled.distance(from: .infinity, to: .position(0)) == -Int.max)
        #expect(cycled.distance(from: .infinity, to: .infinity) == 0)
    }

    @Test("Empty collection distance")
    func emptyDistance() {
        let empty: [Int] = []
        let cycled = empty.cycled()

        #expect(cycled.distance(from: .position(0), to: .position(5)) == 0)
        #expect(cycled.distance(from: .position(0), to: .infinity) == 0)
        #expect(cycled.distance(from: .infinity, to: .position(0)) == 0)
    }

    // MARK: - Lazy Evaluation

    @Test("Lazy evaluation with map")
    func lazyMap() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()
        let lazyMapped = cycled.lazy.map { $0 * 2 }

        var iterator = lazyMapped.makeIterator()
        #expect(iterator.next() == 2)
        #expect(iterator.next() == 4)
        #expect(iterator.next() == 6)
        #expect(iterator.next() == 2)
    }

    @Test("Lazy evaluation with filter")
    func lazyFilter() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()
        let lazyFiltered = cycled.lazy.filter { $0 > 1 }

        var iterator = lazyFiltered.makeIterator()
        #expect(iterator.next() == 2)
        #expect(iterator.next() == 3)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == 3)
    }

    // MARK: - Emoji Handling

    @Test("Cycling with emojis")
    func emojiCycling() {
        let emojis = "😊👍"
        let cycled = emojis.cycled()

        #expect(cycled[0] == "😊")
        #expect(cycled[1] == "👍")
        #expect(cycled[2] == "😊")
        #expect(cycled[3] == "👍")
        #expect(cycled[-1] == "👍")
        #expect(cycled[-2] == "😊")
    }

    @Test("Emoji iterator")
    func emojiIterator() {
        let emojis = "🐱🐶🐰"
        let cycled = emojis.cycled()
        var iterator = cycled.makeIterator()

        #expect(iterator.next() == "🐱")
        #expect(iterator.next() == "🐶")
        #expect(iterator.next() == "🐰")
        #expect(iterator.next() == "🐱")
    }

    // MARK: - For Loop with Prefix

    @Test("For loop with prefix")
    func forLoopWithPrefix() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()
        let prefixed = cycled.prefix(5)

        var result: [Int] = []
        for value in prefixed {
            result.append(value)
        }

        #expect(result == [1, 2, 3, 1, 2])
    }

    @Test("For loop with prefix on empty")
    func forLoopWithPrefixEmpty() {
        let empty: [Int] = []
        let cycled = empty.cycled()
        let prefixed = cycled.prefix(5)

        var result: [Int] = []
        for value in prefixed {
            result.append(value)
        }

        #expect(result.isEmpty)
    }

    @Test("For loop with prefix on emojis")
    func forLoopWithPrefixEmojis() {
        let emojis = "🚀🌍"
        let cycled = emojis.cycled()
        let prefixed = cycled.prefix(4)

        var result: [Character] = []
        for value in prefixed {
            result.append(value)
        }

        #expect(result == ["🚀", "🌍", "🚀", "🌍"])
    }

    // MARK: - Sendable Conformance

    @Test("Sendable conformance")
    func sendable() {
        let numbers = [1, 2, 3]
        let cycled = numbers.cycled()
        let _: any Sendable = cycled

        func useSendable(_ value: some Sendable) {
            if let cycled = value as? CycledCollection<[Int]> {
                #expect(cycled[0] == 1)
            }
        }
        useSendable(cycled)
    }

    // MARK: - Edge Cases

    @Test("Large indices")
    func largeIndices() {
        let numbers = [1, 2]
        let cycled = numbers.cycled()

        #expect(cycled[Int.max - 1] == 1)
        #expect(cycled[Int.max] == 2)
        #expect(cycled[Int.min] == 1)
        #expect(cycled[Int.min + 1] == 2)
    }

    @Test("Non-array collection")
    func nonArrayCollection() {
        let string = "abc"
        let cycled = string.cycled()

        #expect(cycled[0] == "a")
        #expect(cycled[3] == "a")
        #expect(cycled[-1] == "c")
    }
}
