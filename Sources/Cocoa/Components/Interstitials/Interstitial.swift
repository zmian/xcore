//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public enum Interstitial {
    public typealias Identifier = Xcore.Identifier<Interstitial>

    public enum UserState: String, Equatable {
        case new
        case existing
    }
}
