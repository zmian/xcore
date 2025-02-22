//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(WidgetKit)
import SwiftUI
private import WidgetKit

/// An empty widget that displays no content.
///
/// This widget is designed as a placeholder or testing widget that does not
/// show any meaningful content. It can be used when you need a default widget
/// configuration without actual data or UI elements.
///
/// **Usage**
///
/// ```swift
/// @main
/// struct Widgets: WidgetBundle {
///     var body: some Widget {
///         EmptyWidget()
///     }
/// }
/// ```
public struct EmptyWidget: Widget {
    @inlinable public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.xcore.empty-widget", provider: EmptyWidgetProvider()) { _ in
            EmptyView()
        }
        .configurationDisplayName("Empty Widget")
        .description("A widget that displays no content.")
    }
}

// MARK: - TimelineProvider

/// Provides timeline entries for the empty widget.
///
/// This provider supplies a single timeline entry that never refreshes.
private struct EmptyWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .empty
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.empty)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        completion(Timeline(entries: [.empty], policy: .never))
    }
}

// MARK: - TimelineEntry

extension EmptyWidgetProvider {
    /// An empty widget timeline entry.
    struct Entry: TimelineEntry {
        let date: Date

        static var empty: Self {
            .init(date: .distantFuture)
        }
    }
}
#endif
