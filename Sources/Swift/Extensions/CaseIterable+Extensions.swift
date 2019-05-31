//
// CaseIterable+Extensions.swift
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

extension CaseIterable {
    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `allCases.isEmpty` property instead of
    /// comparing count to zero. Unless the collection guarantees random-access performance,
    /// calculating count can be an O(`n`) operation.
    ///
    /// Complexity: O(`1`) if the collection conforms to `RandomAccessCollection`; otherwise,
    /// O(`n`), where `n` is the length of the collection.
    public static var count: Int {
        return allCases.count
    }
}

extension CaseIterable where Self: RawRepresentable {
    /// A collection of all corresponding raw values of this type.
    public static var rawValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}
