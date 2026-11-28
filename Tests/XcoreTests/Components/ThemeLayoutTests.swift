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

        AppConstants.cornerRadius = 20
        #expect(Theme.cornerRadius == 20)
        #expect(Theme.default.cornerRadius == 20)

        Theme.cornerRadius = 12
        #expect(AppConstants.cornerRadius == 12)
    }

    @Test func defaultSpacingForwardsToDefaultTheme() {
        let original = Theme.defaultSpacing
        let originalInter = Theme.interItemHSpacing
        defer {
            Theme.defaultSpacing = original
            Theme.interItemHSpacing = originalInter
        }

        resetThemeSpacingSSOTForParallelTesting()

        CGFloat.defaultSpacing = 24
        #expect(Theme.defaultSpacing == 24)
        CGFloat.defaultSpacing = original
    }

    @Test func spacingScaleMatchesDocumentation() {
        resetThemeSpacingSSOTForParallelTesting()

        #expect(CGFloat.s1 == 4)
        #expect(CGFloat.s5 == CGFloat.defaultSpacing)
        #expect(CGFloat.s3 == CGFloat.interItemHSpacing)
    }

    @Test func listRowInsetsFollowDefaultSpacing() {
        let original = Theme.defaultSpacing
        defer { Theme.defaultSpacing = original }

        resetThemeSpacingSSOTForParallelTesting()

        Theme.defaultSpacing = 16
        #expect(EdgeInsets.listRow == EdgeInsets(16))
        #expect(Theme.listRowInsets == EdgeInsets(16))
    }
}