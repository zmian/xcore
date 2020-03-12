//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
