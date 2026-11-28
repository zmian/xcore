import Testing
import Xcore

@Suite
struct FormattingDefaultsTests {
    @Test func frozenDefaultsMatchDocumentation() {
        #expect(Character.mask == "•")
        #expect(Int.defaultFractionDigits == 2)
        #expect(Int.maxFractionDigits == 100)
        #expect(Int.defaultRandomUpperBound == 100)
        #expect(Double.defaultRandomUpperBound == 100.0)
    }
}