//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Shared defaults for ``CodingFormatStyle`` numeric encoding.
public enum CodingFormatStyleDefaults {
    private static let defaultEncodeAsStringStorage = LockIsolated(false)

    /// When `true`, ``DecimalCodingFormatStyle`` and ``DoubleCodingFormatStyle`` encode as JSON strings.
    public static var defaultEncodeAsString: Bool {
        get { defaultEncodeAsStringStorage.value }
        set { defaultEncodeAsStringStorage.setValue(newValue) }
    }
}