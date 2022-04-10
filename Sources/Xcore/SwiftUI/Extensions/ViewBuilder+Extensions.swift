//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//
// swiftformat:disable all
// swiftlint:disable all

import SwiftUI

// Extend ViewBuilder to handle up to 15 views from 10.

extension ViewBuilder {
    // 11
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>
        (_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10)
        -> TupleView<
            (
                Group<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>,
                Group<TupleView<(C10)>>
            )
        >
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View, C10: View
    {
        TupleView(
            (
                Group { TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)) },
                Group { TupleView((c10)) }
            )
        )
    }

    // 12
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11>
        (_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11)
        -> TupleView<
            (
                Group<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>,
                Group<TupleView<(C10, C11)>>
            )
        >
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View, C10: View, C11: View
    {
        TupleView(
            (
                Group { TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)) },
                Group { TupleView((c10, c11)) }
            )
        )
    }

    // 13
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12>
        (_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12)
        -> TupleView<
            (
                Group<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>,
                Group<TupleView<(C10, C11, C12)>>
            )
        >
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View, C10: View, C11: View, C12: View
    {
        TupleView(
            (
                Group { TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)) },
                Group { TupleView((c10, c11, c12)) }
            )
        )
    }

    // 14
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13>
        (_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13)
        -> TupleView<
            (
                Group<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>,
                Group<TupleView<(C10, C11, C12, C13)>>
            )
        >
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View, C10: View, C11: View, C12: View, C13: View
    {
        TupleView(
            (
                Group { TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)) },
                Group { TupleView((c10, c11, c12, c13)) }
            )
        )
    }

    // 15
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14>
        (_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14)
        -> TupleView<
            (
                Group<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>,
                Group<TupleView<(C10, C11, C12, C13, C14)>>
            )
        >
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View, C10: View, C11: View, C12: View, C13: View, C14: View
    {
        TupleView(
            (
                Group { TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)) },
                Group { TupleView((c10, c11, c12, c13, c14)) }
            )
        )
    }
}
