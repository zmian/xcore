//
// NibInstantiable.swift
//
// Copyright © 2016 Zeeshan Mian
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

/// A type that all `UIView` subclasses conform to.
/// It provides a safe way to load views from nibs.
/// It also eliminates casting as `initFromNib()` method automatically
/// returns the correct `UIView`'s subclass.
///
/// The default `nibName` value is `UIView`'s class name.
/// ```
/// class ProfileView: UIView { }
///
/// print(ProfileView.nibName)
///
/// "ProfileView"
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
///
/// ```
/// If you want to provide your own custom `nibName` you can do so like:
/// ```
/// class ProfileView: UIView {
///     override class var nibName: String { return "Profile" }
/// }
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
/// ```
public protocol NibInstantiable {
    static var nibName: String { get }
}

extension UIView: NibInstantiable {
    public class var nibName: String { return "\(self)" }
}

public extension NibInstantiable where Self: UIView {
    @warn_unused_result
    public static func initFromNib(bundle: NSBundle? = nil) -> Self {
        let bundle = bundle ?? NSBundle(forClass: Self.self)
        return bundle.loadNibNamed(nibName, owner: nil, options: nil).first as! Self
    }
}
