//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Picker.List {
    public typealias Model = PickerListModel

    public enum SelectionStyle {
        case checkmark(tintColor: UIColor)
        case highlight(UIColor)

        public static var checkmark: Self {
            .checkmark(tintColor: appearance().checkmarkTintColor)
        }

        public static var highlight: Self {
            .highlight(appearance().highlightColor)
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
        public lazy var titleNumberOfLines = Self.appearance().titleNumberOfLines

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

        public func present(caller: Any? = nil) {
            DrawerScreen.present(content, caller: caller)
        }

        public func dismiss(caller: Any? = nil) {
            DrawerScreen.dismiss(caller: caller)
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

// MARK: - Appearance

extension Picker.List {
    /// This configuration exists to allow some of the properties to be configured
    /// to match app's appearance style. The `UIAppearance` protocol doesn't work
    /// when the stored properites are set using associated object.
    ///
    /// **Usage:**
    ///
    /// ```swift
    /// Picker.List.appearance().overlayColor = UIColor.black.alpha(0.8)
    /// ```
    final public class Appearance: Appliable {
        fileprivate static var shared = Appearance()

        public var checkmarkTintColor = UIColor.appTint
        public var highlightColor = UIColor.appHighlightedBackground.alpha(0.99)
        public var titleNumberOfLines = 0

        /// The preferred maximum number of items visible without scrolling.
        public var preferredMaxVisibleItemsCount = 5
    }

    public static func appearance() -> Appearance {
        .shared
    }
}
