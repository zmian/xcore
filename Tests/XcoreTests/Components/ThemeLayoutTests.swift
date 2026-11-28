import SwiftUI
import Testing
import Xcore

/// Baseline for `Theme.defaultSpacing` / `interItemHSpacing` under parallel `make test` (see `SPACING_SCALE.md`).
private func resetThemeSpacingSSOTForParallelTesting() {
    Theme.defaultSpacing = .s5
    Theme.interItemHSpacing = .s3
}

@Suite(.serialized)
struct ThemeLayoutTests {
    @Test func cornerRadiusAppConstantsForwardsToDefaultTheme() {
        let original = Theme.cornerRadius
        defer {
            Theme.cornerRadius = original
            #expect(AppConstants.cornerRadius == original)
        }

        AppConstants.cornerRadius = .s5
        #expect(Theme.cornerRadius == .s5)
        #expect(Theme.default.cornerRadius == .s5)

        Theme.cornerRadius = .s3
        #expect(AppConstants.cornerRadius == .s3)
    }

    @Test func defaultSpacingForwardsToDefaultTheme() {
        let original = Theme.defaultSpacing
        let originalInter = Theme.interItemHSpacing
        defer {
            Theme.defaultSpacing = original
            Theme.interItemHSpacing = originalInter
        }

        resetThemeSpacingSSOTForParallelTesting()

        CGFloat.defaultSpacing = .s6
        #expect(Theme.defaultSpacing == .s6)
        CGFloat.defaultSpacing = original
    }

    @Test func spacingScaleMatchesDocumentation() {
        resetThemeSpacingSSOTForParallelTesting()

        #expect(CGFloat.s3 == CGFloat.s2 + CGFloat.s1)
        #expect(CGFloat.s5 == CGFloat.defaultSpacing)
        #expect(CGFloat.s3 == CGFloat.interItemHSpacing)
    }

    @Test func listRowInsetsFollowDefaultSpacing() {
        let original = Theme.defaultSpacing
        defer { Theme.defaultSpacing = original }

        resetThemeSpacingSSOTForParallelTesting()

        Theme.defaultSpacing = .s4
        #expect(EdgeInsets.listRow == EdgeInsets(.s4))
        #expect(Theme.listRowInsets == EdgeInsets(.s4))
    }
}