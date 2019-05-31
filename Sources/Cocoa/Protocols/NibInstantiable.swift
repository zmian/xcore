//
// NibInstantiable.swift
//
// Copyright © 2016 Xcore
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
/// The default `nibIdentifier` value is `UIView`'s class name.
/// ```swift
/// class ProfileView: UIView { }
///
/// print(ProfileView.nibIdentifier)
///
/// "ProfileView"
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
///
/// ```
/// If you want to provide your own custom `nibIdentifier` you can do so like:
/// ```swift
/// class ProfileView: UIView {
///     class var nibIdentifier: String { return "Profile" }
/// }
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
/// ```
public protocol NibInstantiable {
    static var nibIdentifier: String { get }
}

extension NibInstantiable {
    public static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension NibInstantiable where Self: UIView {
    /// Instantiates and returns the nib of type `Self`.
    ///
    /// - Parameter bundle: The bundle containing the nib file and its related resources.
    ///                     If `nil`, then this method looks in the main bundle of the current
    ///                     application. The default value is `nil`.
    /// - Returns: The nib of type `Self`.
    public static func initFromNib(bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: Self.self)
        return bundle.loadNibNamed(nibIdentifier, owner: nil, options: nil)!.first as! Self
    }
}

extension UIView: NibInstantiable { }
