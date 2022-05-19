//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FeatureFlag {
    public static var oneTimeCodeCharacterLimit: Int {
        Key("one_time_code_character_limit").value(default: 6)
    }
}
