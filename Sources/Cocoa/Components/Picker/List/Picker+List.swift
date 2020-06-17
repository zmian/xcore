//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Picker.List {
    public typealias Model = PickerListModel
    public static var checkmarkDefaultTintColor = UIColor.appTint
    public static var highlightDefaultColor = UIColor.appHighlightedBackground.alpha(0.8)

    public enum SelectionStyle {
        case checkmark(tintColor: UIColor)
        case highlight(UIColor)

        public static var checkmark: Self {
            .checkmark(tintColor: checkmarkDefaultTintColor)
        }

        public static var highlight: Self {
            .highlight(highlightDefaultColor)
        }
    }
}

extension Picker {
    final public class List: Appliable {
        private let content: Content

        public init(model: Model) {
            content = Content(model: model)
        }

        public lazy var selectionStyle: SelectionStyle = .highlight

        public var isToolbarHidden: Bool {
            get { content.isToolbarHidden }
            set { content.isToolbarHidden = newValue }
        }

        /// The animation to use when reloading the table.
        public var reloadAnimation: UITableView.RowAnimation {
            get { content.reloadAnimation }
            set { content.reloadAnimation = newValue }
        }

        /// The preferred maximum number of items visible without scrolling.
        public var preferredMaxVisibleItemsCount: Int {
            get { content.preferredMaxVisibleItemsCount }
            set { content.preferredMaxVisibleItemsCount = newValue }
        }

        public func present() {
            DrawerScreen.present(content)
        }

        public func dismiss() {
            DrawerScreen.dismiss()
        }

        /// Reloads all components of the picker view.
        ///
        /// Calling this method causes the picker view to query the delegate for new
        /// data for all components.
        public func reloadData() {
            content.reloadData()
        }
    }
}
