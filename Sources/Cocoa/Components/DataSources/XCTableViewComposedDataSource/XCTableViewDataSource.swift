//
// XCTableViewDataSource.swift
// Based on https://github.com/ortuman/ComposedDataSource
//
// Copyright © 2014 Xcore
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

@objcMembers
open class XCTableViewDataSource: NSObject, UITableViewDataSource {
    /// UITableView has bug that ignored zero when sent as the `heightForFooterInSection`
    /// It has to be number greater then zero. Hence, this declaration.
    public static let zero: CGFloat = 0.0001

    /// Global section index.
    open var globalSection = 0

    /// The table view of the data source.
    open weak var tableView: UITableView?

    /// A convenience property to access data source's navigation controller.
    open var navigationController: UINavigationController? {
        return tableView?.viewController?.navigationController
    }

    override init() {
        super.init()
    }

    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
}

// MARK: UITableViewDelegate

extension XCTableViewDataSource {
    open func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func heightForHeaderInSection(_ section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func heightForFooterInSection(_ section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: UITableViewDataSource

extension XCTableViewDataSource {
    @objc(numberOfSectionsInTableView:)
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @objc(tableView:cellForRowAtIndexPath:)
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError(because: .subclassMustImplement)
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
}
