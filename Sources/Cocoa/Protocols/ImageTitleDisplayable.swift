//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol ImageTitleDisplayable {
    var title: StringRepresentable { get }
    var subtitle: StringRepresentable? { get }
    var image: ImageRepresentable? { get }
}

extension ImageTitleDisplayable {
    public var subtitle: StringRepresentable? {
        nil
    }
}
