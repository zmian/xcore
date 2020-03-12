//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Currency.Components {
    /// A structure that represent formatting attributes for currency components.
    public struct Attributes: Equatable {
        public let dollarsFont: UIFont
        public let centsFont: UIFont
        public let centsOffset: Int

        public init(dollarsFont: UIFont, centsFont: UIFont, centsOffset: Int) {
            self.dollarsFont = dollarsFont
            self.centsFont = centsFont
            self.centsOffset = centsOffset
        }
    }
}
