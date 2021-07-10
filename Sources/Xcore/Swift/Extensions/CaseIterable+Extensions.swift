//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

extension CaseIterable {
    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `allCases.isEmpty` property
    /// instead of comparing count to zero. Unless the collection guarantees
    /// random-access performance, calculating count can be an O(`n`) operation.
    ///
    /// Complexity: O(`1`) if the collection conforms to `RandomAccessCollection`;
    /// otherwise, O(`n`), where `n` is the length of the collection.
    public static var count: Int {
        allCases.count
    }
}

extension CaseIterable where Self: RawRepresentable {
    /// A collection of all corresponding raw values of this type.
    public static var rawValues: [RawValue] {
        allCases.map(\.rawValue)
    }
}
