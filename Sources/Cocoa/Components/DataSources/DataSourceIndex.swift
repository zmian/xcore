//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A helper struct to store composed data source sections and data sources.
struct DataSourceIndex<DataSourceType> {
    private typealias GlobalSection = Int
    private typealias DataSource = (dataSource: DataSourceType, localSection: Int)
    private var index = [GlobalSection: DataSource]()

    subscript(_ section: Int) -> (dataSource: DataSourceType, localSection: Int) {
        get { index[section]! }
        set { index[section] = newValue }
    }
}

public struct DataSource<DataSourceType> {
    public let dataSource: DataSourceType
    public let globalSection: Int
    public let localSection: Int
}
