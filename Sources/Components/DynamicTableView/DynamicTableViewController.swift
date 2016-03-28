//
// DynamicTableViewController.swift
//
// Copyright © 2016 Zeeshan Mian
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

public class DynamicTableViewController: UIViewController {
    public private(set) lazy var tableView: DynamicTableView = DynamicTableView(style: self.style, options: self.cellOptions)
    /// Style must be set before accessing `tableView` to ensure that it is applied correctly.
    public var style: UITableViewStyle = .Plain
    public var cellOptions: DynamicTableCellOptions = [] {
        didSet {
            if isViewLoaded() {
                tableView.cellOptions = cellOptions
            }
        }
    }

    /// An option to determine whether the `scrollView`'s `top` and `bottom` is constrained
    /// to `topLayoutGuide` and `bottomLayoutGuide`. The default value is `[]`.
    public var constraintToLayoutGuideOptions: LayoutGuideOptions = []

    // MARK: Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(style: UITableViewStyle) {
        self.init(style: style, options: [])
    }

    public convenience init(style: UITableViewStyle = .Plain, options: DynamicTableCellOptions) {
        self.init(nibName: nil, bundle: nil)
        self.style       = style
        self.cellOptions = options
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellOptions = cellOptions
        setupSubviews()
        setupDynamicTableView()
    }

    private func setupDynamicTableView() {
        view.addSubview(tableView)
        constraintsForViewToFillSuperview(tableView, constraintToLayoutGuideOptions: constraintToLayoutGuideOptions).activate()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// for example, add new subviews or configure properties.
    /// This method is called when `viewDidLoad` method is invoked.
    public func setupSubviews() {}
}
