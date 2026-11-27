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
}