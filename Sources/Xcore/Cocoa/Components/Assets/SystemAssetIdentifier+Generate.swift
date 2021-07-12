//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

#if DEBUG
extension String {
    /// **Usage**
    ///
    /// ```swift
    /// func generateSystemIdentifiers() {
    ///     let symbolNames: [String] = [
    ///         "square.and.arrow.up",
    ///         "square.and.arrow.up.fill",
    ///         "50.square",
    ///         "50.square.fill"
    ///     ]
    ///
    ///     symbolNames.forEach { symbol in
    ///         print(symbol._generateSystemIdentifier())
    ///     }
    /// }
    /// ```
    ///
    /// Returns `self` as `SystemAssertIdentifier` property representation.
    func _generateSystemIdentifier() -> String {
        let name = transform(camelcased())

        return """
        /// `\(self)`
        public static var \(name): Self { "\(self)" }
        """
    }

    private func transform(_ input: String) -> String {
        let map: [(current: String, new: String, onlyIfInTheMiddle: Bool)] = [
            ("externaldrive", "externalDrive", false),
            ("opticaldiscdrive", "opticalDiscDrive", false),
            ("internaldrive", "internalDrive", false),
            ("archivebox", "archiveBox", false),
            ("4kTv", "fourKTv", false),
            ("hifispeaker", "hifiSpeaker", false),
            ("Gearshape", "GearShape", false),
            ("deskclock", "deskClock", false),
            ("lifepreserver", "lifePreserver", false),

            ("squareshape", "squareShape", true),
            ("arrowshape", "arrowShape", true),
            ("handles", "Handles", true),
            ("mark", "Mark", true),
            ("grid", "Grid", true),
            ("path", "Path", true),
            ("right", "Right", true),
            ("left", "Left", true),
            ("half", "Half", true),
            ("top", "Top", true),
            ("bottom", "Bottom", true),
            ("leading", "Leading", true),
            ("trailing", "Trailing", true),
            ("badge", "Badge", true),
            ("triangle", "Triangle", true),
            ("quarter", "Quarter", true),

            ("macpro", "macPro", false),
            ("flipphone", "flipPhone", false),
            ("candybarphone", "candybarPhone", false),
            ("Batteryblock", "BatteryBlock", false),
            ("Homebutton", "HomeButton", false),

            ("ipodshuffle", "ipodShuffle", false),
            ("airpodpro", "airpodPro", false),
            ("macmini", "macMini", false),

            ("Magnifyingglass", "MagnifyingGlass", false),
            ("magnifyingglass", "magnifyingGlass", false),

            ("applelogo", "appleLogo", false),

            ("case", "`case`", false),
            ("`case`Fill", "caseFill", false),

            ("return", "`return`", false),
            ("switch", "`switch`", false),
            ("`switch`2", "switch2", false),

            ("macwindow", "macWindow", false),
            ("togglepower", "togglePower", false),
            ("poweron", "powerOn", false),
            ("poweroff", "powerOff", false),
            ("powersleep", "powerSleep", false),
            ("3x", "3X", false),
            ("2x", "2X", false),
            ("1x", "1X", false),
            ("faxmachine", "faxMachine", false),
            ("lapTopcomputer", "laptopComputer", false),
            ("bookMark", "bookmark", false),
            ("BookMark", "Bookmark", false),
            ("CheckMark", "Checkmark", false),
            ("checkMark", "checkmark", false)
        ]

        var input = input

        for replacement in map {
            if replacement.onlyIfInTheMiddle, !input.starts(with: replacement.current) {
                input = input.replacingOccurrences(of: replacement.current, with: replacement.new)
            } else {
                input = input.replacingOccurrences(of: replacement.current, with: replacement.new)
            }
        }

        // If first letter is a number
        if let first = input.first.map({ CharacterSet(charactersIn: String($0)) }), first.isSubset(of: .numbers) {
            input = "number" + input
        }

        return input
    }
}
#endif
