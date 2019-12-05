//
// StackingDataSourceViewModel.swift
//
// Copyright © 2019 Xcore
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

public protocol StackingDataSourceViewModel {
    var tileIdentifier: String { get }
    var numberOfSections: Int { get }
    func itemsCount(for section: Int) -> Int
    func item(at index: IndexPath) -> Any?
    func didChange(_ callback: @escaping () -> Void)
    func didTap(at index: IndexPath)
    var isShadowEnabled: Bool { get }

    var isClearButtonHidden: Bool { get }
    func clearAll()

    var clearButtonTitle: String { get }
    var showLessButtonTitle: String { get }
}

extension StackingDataSourceViewModel {
    public func itemsCount(for section: Int) -> Int {
        1
    }

    public var isEmpty: Bool {
        let sectionsCount = numberOfSections
        guard sectionsCount > 0 else {
            return true
        }

        for section in 0..<sectionsCount {
            if itemsCount(for: section) > 0 {
                return false
            }
        }
        return true
    }
}
