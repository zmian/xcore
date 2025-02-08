//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import SwiftUI
@testable import Xcore

struct GeometryTests {
    @Test
    func edgeConvenienceProperties() {
        var edgeSet = Edge.leading
        #expect(edgeSet.isHorizontal)
        #expect(!edgeSet.isVertical)

        edgeSet = Edge.trailing
        #expect(edgeSet.isHorizontal)
        #expect(!edgeSet.isVertical)

        edgeSet = Edge.top
        #expect(!edgeSet.isHorizontal)
        #expect(edgeSet.isVertical)

        edgeSet = Edge.bottom
        #expect(!edgeSet.isHorizontal)
        #expect(edgeSet.isVertical)
    }

    @Test
    func horizontalEdgeSetToEdgeSet() {
        let horizontalSet: HorizontalEdge.Set = [.leading, .trailing]
        let edgeSet = Edge.Set(horizontalSet)

        #expect(edgeSet.contains(.leading))
        #expect(edgeSet.contains(.trailing))
        #expect(edgeSet == [.leading, .trailing])
        #expect(!edgeSet.contains(.top))
        #expect(!edgeSet.contains(.bottom))
    }

    @Test
    func verticalEdgeSetToEdgeSet() {
        let verticalSet: VerticalEdge.Set = [.top, .bottom]
        let edgeSet = Edge.Set(verticalSet)

        #expect(edgeSet.contains(.top))
        #expect(edgeSet.contains(.bottom))
        #expect(edgeSet == [.top, .bottom])
        #expect(!edgeSet.contains(.leading))
        #expect(!edgeSet.contains(.trailing))
    }
}
