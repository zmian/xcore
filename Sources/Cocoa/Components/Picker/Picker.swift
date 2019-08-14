//
// Picker.swift
//
// Copyright © 2019 Xcore
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

final public class Picker: With {
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
