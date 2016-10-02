//
// XCTableViewComposedDataSource.swift
// Based on https://github.com/ortuman/ComposedDataSource
//
// Copyright © 2014 Zeeshan Mian
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

open class XCTableViewComposedDataSource: XCTableViewDataSource {
    fileprivate typealias GlobalSection = Int
    fileprivate typealias DataSource = (dataSource: XCTableViewDataSource, localSection: Int)
    fileprivate var dataSourceIndex = [GlobalSection: DataSource]()

    open var dataSources: [XCTableViewDataSource] = []

    override init () {
        super.init()
    }

    convenience init(dataSources: [XCTableViewDataSource]) {
        self.init()
        self.dataSources = dataSources
    }

    // MARK: Public Interface

    /// A convenience method to replace all exisiting data sources and register cells.
    open func replace(dataSources: [XCTableViewDataSource], for tableView: UITableView) {
        self.dataSources = dataSources
        registerClasses(for: tableView)
    }

    open func append(dataSource: XCTableViewDataSource) {
        dataSources.append(dataSource)
    }

    open func remove(dataSource: XCTableViewDataSource) {
        if let index = dataSources.index(of: dataSource) {
            dataSources.remove(at: index)
        }
    }

    open override func registerClasses(for tableView: UITableView) {
        dataSources.forEach {
            $0.registerClasses(for: tableView)
        }
    }
}

// MARK: UITableViewDataSource

extension XCTableViewComposedDataSource {
    open override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        let dataSourcesCount = dataSources.count

        for i in 0..<dataSourcesCount {
            var dataSourceSections = 1
            let dataSource = dataSources[i]

            if dataSource.responds(to: #selector(self.numberOfSections(in:))) {
                dataSourceSections = dataSource.numberOfSections(in: tableView)
            }

            var localSection = 0

            while dataSourceSections > 0 {
                dataSources[i].globalSection = numberOfSections
                dataSourceIndex[numberOfSections] = (dataSources[i], localSection)
                localSection += 1
                numberOfSections += 1
                dataSourceSections -= 1
            }
        }

        return numberOfSections
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.tableView(tableView, numberOfRowsInSection:localSection)
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (dataSource, localSection) = dataSourceIndex[(indexPath as NSIndexPath).section]!
        let localIndexPath = IndexPath(row: (indexPath as NSIndexPath).row, section: localSection)
        return dataSource.tableView(tableView, cellForRowAt: localIndexPath)
    }

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.tableView(tableView, titleForHeaderInSection: localSection)
    }

    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.tableView(tableView, titleForFooterInSection: localSection)
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.tableView(tableView, viewForHeaderInSection: localSection)
    }

    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.tableView(tableView, viewForFooterInSection: localSection)
    }
}

// MARK: UITableViewDataSource

extension XCTableViewComposedDataSource {
    open override func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let (dataSource, localSection) = dataSourceIndex[(indexPath as NSIndexPath).section]!
        let localIndexPath = IndexPath(row: (indexPath as NSIndexPath).row, section: localSection)
        return dataSource.heightForRow(at: localIndexPath)
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[(indexPath as NSIndexPath).section]!
        let localIndexPath = IndexPath(row: (indexPath as NSIndexPath).row, section: localSection)
        dataSource.tableView(tableView, didSelectRowAt: localIndexPath)
    }

    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[(indexPath as NSIndexPath).section]!
        let localIndexPath = IndexPath(row: (indexPath as NSIndexPath).row, section: localSection)
        dataSource.tableView(tableView, willDisplay: cell, forRowAt: localIndexPath)
    }

    open override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[(indexPath as NSIndexPath).section]!
        let localIndexPath = IndexPath(row: (indexPath as NSIndexPath).row, section: localSection)
        dataSource.tableView(tableView, didEndDisplaying: cell, forRowAt: localIndexPath)
    }

    // Header and Footer

    open override func titleForHeaderInSection(_ section: Int) -> String? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.titleForHeaderInSection(localSection)
    }

    open override func titleForFooterInSection(_ section: Int) -> String? {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.titleForFooterInSection(localSection)
    }

    open override func heightForHeaderInSection(_ section: Int) -> CGFloat {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.heightForHeaderInSection(localSection)
    }

    open override func heightForFooterInSection(_ section: Int) -> CGFloat {
        let (dataSource, localSection) = dataSourceIndex[section]!
        return dataSource.heightForFooterInSection(localSection)
    }
}
