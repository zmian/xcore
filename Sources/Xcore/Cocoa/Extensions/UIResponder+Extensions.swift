//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UIResponder {
    /// Returns the responder of type `T`.
    ///
    /// ```swift
    /// extension UICollectionViewCell {
    ///     func configure() {
    ///         if let collectionView = responder() as? UICollectionView {
    ///
    ///         }
    ///     }
    /// }
    /// ```
    public func responder<T: UIResponder>() -> T? {
        var responder: UIResponder = self
        while let nextResponder = responder.next {
            responder = nextResponder
            if responder is T {
                return responder as? T
            }
        }
        return nil
    }
}
#endif
