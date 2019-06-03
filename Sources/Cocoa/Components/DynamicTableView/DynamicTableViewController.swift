//
// DynamicTableViewController.swift
//
// Copyright © 2016 Xcore
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

open class DynamicTableViewController: UIViewController {
    private var tableViewConstraints: NSLayoutConstraint.Edges!
    open private(set) lazy var tableView = DynamicTableView(style: self.style, options: self.cellOptions)
    /// Style must be set before accessing `tableView` to ensure that it is applied correctly.
    open var style: UITableView.Style = .plain
    open var cellOptions: CellOptions = .none {
        didSet {
            guard isViewLoaded else { return }
            tableView.cellOptions = cellOptions
        }
    }

    /// The distance that the tableView is inset from the enclosing view.
    ///
    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets = 0 {
        didSet {
            tableViewConstraints.update(from: contentInset)
        }
    }

    // MARK: - Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(style: UITableView.Style) {
        self.init(style: style, options: .none)
    }

    public convenience init(style: UITableView.Style = .plain, options: CellOptions) {
        self.init(nibName: nil, bundle: nil)
        self.style = style
        self.cellOptions = options
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDynamicTableView()
    }

    private func setupDynamicTableView() {
        if !cellOptions.isEmpty && tableView.cellOptions.isEmpty {
            tableView.cellOptions = cellOptions
        }

        view.addSubview(tableView)
        tableViewConstraints = NSLayoutConstraint.Edges(
            tableView.anchor.edges.equalToSuperview().inset(contentInset).constraints
        )
    }
}
