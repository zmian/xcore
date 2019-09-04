//
// SearchBarView.swift
//
// Copyright © 2017 Xcore
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

extension SearchBarView {
    public enum SeparatorPosition {
        case top
        case bottom
    }
}

final public class SearchBarView: UIView {
    private var searchBarTrailingConstraint: NSLayoutConstraint?
    private var containerViewConstraints: NSLayoutConstraint.Edges!
    private let containerView = UIView()
    private let searchBar = UISearchBar()
    private let topSeparatorView = SeparatorView()
    private let bottomSeparatorView = SeparatorView()

    private var searchBarTrailingPadding: CGFloat {
        return style == .minimal ? .defaultPadding - .minimumPadding : 0
    }

    @objc dynamic public var style: UISearchBar.Style = .default {
        didSet {
            guard oldValue != style else { return }
            updateStyle()
        }
    }

    /// The default value is `.zero`.
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            guard style == .minimal, oldValue != contentInset else { return }
            containerViewConstraints.update(from: contentInset)
        }
    }

    public var placeholder: String? {
        get { return searchBar.placeholder }
        set { searchBar.placeholder = newValue }
    }

    public var text: String? {
        return searchBar.text
    }

    @objc dynamic public override var tintColor: UIColor! {
        get { return searchBar.tintColor }
        set { searchBar.tintColor = newValue }
    }

    @objc dynamic public var placeholderTextColor: UIColor? {
        get { return searchBar.placeholderTextColor }
        set { searchBar.placeholderTextColor = newValue }
    }

    private lazy var _searchFieldBackgroundColor: UIColor = {
        searchBar.searchFieldBackgroundColor ?? UIColor.appBackgroundDisabled.alpha(0.3)
    }()

    @objc dynamic public var searchFieldBackgroundColor: UIColor {
        get { return _searchFieldBackgroundColor }
        set {
            _searchFieldBackgroundColor = newValue
            updateSearchFieldBackgroundColorIfNeeded()
        }
    }

    public init(placeholder: String = "Search") {
        super.init(frame: .zero)
        commonInit()
        // This must be called after the `UISearchBar` is added as subview
        // otherwise the placeholder will not be correctly configured.
        self.placeholder = placeholder
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white
        setupSearchBar()
        setupConstraints()
        updateStyle()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white

        // Update clear button image tint color
        setImage(assetIdentifier: .closeIconFilled, for: .clear, size: 16)
    }

    private func setupConstraints() {
        addSubview(containerView)

        containerView.anchor.make {
            $0.height.equalTo(AppConstants.searchBarHeight)
            let constraints = $0.edges.equalToSuperview().constraints
            containerViewConstraints = NSLayoutConstraint.Edges(constraints)
        }

        containerView.addSubview(searchBar)
        searchBar.anchor.make {
            $0.vertically.equalToSuperview()
            $0.leading.equalToSuperview()
            searchBarTrailingConstraint = $0.trailing.equalToSuperview().inset(searchBarTrailingPadding).constraints.first
        }

        containerView.addSubview(topSeparatorView)
        topSeparatorView.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.top.equalToSuperview()
        }

        containerView.addSubview(bottomSeparatorView)
        bottomSeparatorView.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func updateStyle() {
        var magnifyingGlassSize: CGFloat?

        switch style {
            case .minimal:
                searchBar.searchBarStyle = .default
                searchBar.searchTextPositionAdjustment.horizontal = .minimumPadding
                searchBar.backgroundImage = UIImage()
            default:
                searchBar.searchBarStyle = .minimal
                setSeparatorHidden(true, for: .top, .bottom)
                magnifyingGlassSize = 14
                updateSearchFieldBackgroundColorIfNeeded()
        }

        // Update built-in magnifying glass so the tint matches the app tint color
        setImage(assetIdentifier: .searchIcon, for: .search, size: magnifyingGlassSize)

        searchBarTrailingConstraint?.constant = searchBarTrailingPadding
    }

    private func updateSearchFieldBackgroundColorIfNeeded() {
        guard style != .minimal else {
            return
        }

        searchBar.searchFieldBackgroundColor = searchFieldBackgroundColor
    }

    private func setImage(assetIdentifier: ImageAssetIdentifier, for icon: UISearchBar.Icon, size: CGFloat? = nil) {
        let image = UIImage(assetIdentifier: assetIdentifier)

        guard let size = size else {
            searchBar.setImage(image, for: icon, state: .normal)
            return
        }

        let scaledImage = image.scaled(to: CGSize(size), scalingMode: .aspectFit, tintColor: tintColor).withRenderingMode(.alwaysTemplate)
        searchBar.setImage(scaledImage, for: icon, state: .normal)
    }

    private var didBeginEditing: (() -> Void)?
    public func didBeginEditing(_ callback: @escaping () -> Void) {
        didBeginEditing = callback
    }

    private var didChangeText: ((String) -> Void)?
    public func didChangeText(_ callback: @escaping (String) -> Void) {
        didChangeText = callback
    }

    private var didTapDone: (() -> Void)?
    public func didTapDone(_ callback: @escaping () -> Void) {
        didTapDone = callback
    }

    private var didTapCancel: (() -> Void)?
    public func didTapCancel(_ callback: @escaping () -> Void) {
        didTapCancel = callback
    }
}

extension SearchBarView {
    public func hideKeyboardIfNeeded() {
        guard searchBar.isFirstResponder else { return }

        // Only hide cancel button if no text is present in the search bar
        if searchBar.text == nil || (searchBar.text != nil && searchBar.text!.isEmpty) {
            searchBar.setShowsCancelButton(false, animated: true)
        }

        resignFirstResponder()
    }

    public override var isFirstResponder: Bool {
        return searchBar.isFirstResponder
    }

    /// This method sets the text property to `nil` and hides the `cancel` button.
    public func clear() {
        searchBar.text = nil
        hideKeyboardIfNeeded()
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return searchBar.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return searchBar.resignFirstResponder()
    }
}

extension SearchBarView {
    public func setSeparatorHidden(_ hide: Bool, for position: SeparatorPosition...) {
        position.forEach {
            switch $0 {
                case .top:
                    topSeparatorView.isHidden = hide
                case .bottom:
                    bottomSeparatorView.isHidden = hide
            }
        }
    }
}

extension SearchBarView: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        didBeginEditing?()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        didChangeText?(searchText)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clear()
        didTapCancel?()
        didChangeText?("")
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboardIfNeeded()
    }
}
