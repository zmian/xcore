//
// XCTableViewDataSource.swift
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

open class XCTableViewDataSource: NSObject, UITableViewDataSource {
    /// UITableView has bug that ignored zero when sent as the `heightForFooterInSection`
    /// It has to be number greater then zero. Hence, this declaration.
    public static let zero: CGFloat = 0.0001

    open var section = 0

    // MARK: Public Interface

    /// Hide the the section header and section footer views if titles are not provided. The default is `false`.
    ///
    /// This defaults to `false` for developers' sanity when
    /// subclasses implement custom section header and footer views and forgets to
    /// set this property to `false`. So, we are setting it to `false` by default.
    /// Being explicit and asking for such functionality is the right choice.
    /// UIKit's `UIPageControl` also takes this approach for `hidesForSinglePage` property
    /// and defaults to `false`.
    open var hideDefaultHeadersWithoutTitles = false

    open func titleForHeaderInSection(_ section: Int) -> String? {
        return nil
    }

    open func titleForFooterInSection(_ section: Int) -> String? {
        return nil
    }

    open func registerCell(forTableView tableView: UITableView) {
    }
}

// MARK: UITableViewDelegate

extension XCTableViewDataSource {
    open func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    open func heightForHeaderInSection(_ section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    open func heightForFooterInSection(_ section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {

    }

    open func tableView(_ tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {

    }

    open func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

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
        return UITableViewCell(style: .default, reuseIdentifier: "__reuseIdentifier__")
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForHeaderInSection(section)
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.titleForFooterInSection(section)
    }
}
