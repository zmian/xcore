//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class DynamicTableViewController: UIViewController {
    private var tableViewConstraints: NSLayoutConstraint.Edges!
    open private(set) lazy var tableView = DynamicTableView(style: style, options: cellOptions)
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
        view.backgroundColor = Theme.current.backgroundColor
        setupDynamicTableView()
        didLoadView?(self)
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

    private var didLoadView: ((DynamicTableViewController) -> Void)?
    open func didLoadView(_ callback: @escaping (DynamicTableViewController) -> Void) {
        didLoadView = callback
    }
}
