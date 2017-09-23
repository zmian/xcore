//
// UIApplication+SharedOrNil.swift
//
// Copyright © 2017 Zeeshan Mian
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

extension UIApplication {
    /// Swift doesn't allow marking parts of Swift framework unavailable for the App Extension target.
    /// This solution let's us overcome this limitation for now.
    ///
    /// `UIApplication.shared` is marked as unavailable for these for App Extension target.
    ///
    /// https://bugs.swift.org/browse/SR-1226 is still unresolved
    /// and cause problems. It seems that as of now, marking API as unavailable
    /// for extensions in Swift still doesn’t let you compile for App extensions.
    static var sharedOrNil: UIApplication? {
        let sharedApplicationSelector = NSSelectorFromString("sharedApplication")

        guard UIApplication.responds(to: sharedApplicationSelector) else {
            return nil
        }

        guard let unmanagedSharedApplication = UIApplication.perform(sharedApplicationSelector) else {
            return nil
        }

        return unmanagedSharedApplication.takeUnretainedValue() as? UIApplication
    }
}

