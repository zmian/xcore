import SwiftUI
import Testing
import Xcore

@Suite
struct ThemeLayoutTests {
    @Test func cornerRadiusAppConstantsForwardsToDefaultTheme() {
        let original = Theme.cornerRadius
        defer {
            Theme.cornerRadius = original
            #expect(AppConstants.cornerRadius == original)
        }

        AppConstants.cornerRadius = 20
        #expect(Theme.cornerRadius == 20)
        #expect(Theme.default.cornerRadius == 20)

        Theme.cornerRadius = 12
        #expect(AppConstants.cornerRadius == 12)
    }

    @Test func defaultSpacingForwardsToDefaultTheme() {
        let original = Theme.defaultSpacing
        defer { Theme.defaultSpacing = original }

        CGFloat.defaultSpacing = 24
        #expect(Theme.defaultSpacing == 24)
        CGFloat.defaultSpacing = original
    }

    @Test func spacingScaleMatchesDocumentation() {
        // Reset theme metrics so parallel tests cannot pollute forwarder reads.
        Theme.defaultSpacing = 20
        Theme.interItemHSpacing = 12

        #expect(CGFloat.s1 == 4)
        #expect(CGFloat.s5 == CGFloat.defaultSpacing)
        #expect(CGFloat.s3 == CGFloat.interItemHSpacing)
    }

    @Test func listRowInsetsFollowDefaultSpacing() {
        let original = Theme.defaultSpacing
        defer { Theme.defaultSpacing = original }

        // Reset theme metrics so parallel tests cannot pollute forwarder reads.
        Theme.defaultSpacing = 20
        Theme.interItemHSpacing = 12

        Theme.defaultSpacing = 16
        #expect(EdgeInsets.listRow == EdgeInsets(16))
        #expect(Theme.listRowInsets == EdgeInsets(16))
    }
}