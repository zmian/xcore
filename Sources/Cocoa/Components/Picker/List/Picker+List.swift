//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Picker {
    final public class List: Appliable {
        public typealias Model = PickerListModel
        public static var checkmarkTintColor = UIColor.appTint

        private let content: Content

        public init(model: Model) {
            content = Content(model: model)
        }

        /// The animation to use when reloading the table.
        public var reloadAnimation: UITableView.RowAnimation {
            get { content.reloadAnimation }
            set { content.reloadAnimation = newValue }
        }

        /// The maximum number of items visible without scrolling.
        public var maxVisibleItemsCount: Int {
            get { content.maxVisibleItemsCount }
            set { content.maxVisibleItemsCount = newValue }
        }

        public var isToolbarHidden: Bool {
            get { content.isToolbarHidden }
            set { content.isToolbarHidden = newValue }
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
