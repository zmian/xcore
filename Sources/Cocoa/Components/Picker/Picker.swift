//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final public class Picker: Appliable {
    private let content: Content

    public init(model: PickerModel) {
        content = Content(model: model)
    }

    public func present() {
        content.present()
    }

    public func dismiss() {
        content.dismiss()
    }

    public func didTapOtherButton(_ callback: @escaping () -> Void) {
        content.didTapOtherButton(callback)
    }

    /// Reloads all components of the picker view.
    ///
    /// Calling this method causes the picker view to query the delegate for new
    /// data for all components.
    public func reloadData() {
        content.reloadData()
    }

    public func setTitle(_ title: StringRepresentable?) {
        content.setTitle(title)
    }
}
