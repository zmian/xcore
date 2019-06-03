//
// UIKit+Extensions.swift
//
// Copyright © 2014 Xcore
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
import SafariServices
import ObjectiveC

/// Attempts to open the resource at the specified URL.
///
/// Requests are made using `SafariViewController` if available;
/// otherwise it uses `UIApplication:openURL`.
///
/// - Parameters:
///   - url:  The url to open.
///   - from: A view controller that wants to open the url.
public func open(url: URL, from viewController: UIViewController) {
    let svc = SFSafariViewController(url: url)
    viewController.present(svc, animated: true, completion: nil)
}

extension UIDatePicker {
    @nonobjc
    open var textColor: UIColor? {
        get { return value(forKey: "textColor") as? UIColor }
        set { setValue(newValue, forKey: "textColor") }
    }
}
