//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Shared defaults for ``CodingFormatStyle`` numeric encoding.
public enum CodingFormatStyleDefaults {
    /// When `true`, ``DecimalCodingFormatStyle`` and ``DoubleCodingFormatStyle`` encode as JSON strings.
    nonisolated(unsafe) public static var defaultEncodeAsString = false
}