//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FormatStyle where Self == Date.RelativeFormatStyle {
    /// Returns a relative date format style based on the named presentation and
    /// wide unit style.
    public static var relative: Self {
        .relative(presentation: .named)
    }
}

extension Date.RelativeFormatStyle {
    /// The capitalization context to use when formatting the relative dates.
    ///
    /// Setting the capitalization context to `beginningOfSentence` sets the first
    /// word of the relative date string to upper-case. A capitalization context set
    /// to `middleOfSentence` keeps all words in the string lower-cased.
    public func capitalizationContext(_ context: FormatStyleCapitalizationContext) -> Self {
        applying {
            $0.capitalizationContext = context
        }
    }

    public func calendar(_ calendar: Calendar) -> Self {
        applying {
            $0.calendar = calendar
        }
    }

    private func applying(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var object = self
        try configure(&object)
        return object
    }
}
