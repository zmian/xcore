//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that displays Instagram-style stories with a top progress indicator.
///
/// This view presents a sequence of story pages that auto-advance after a given
/// duration. The top progress bar visually indicates the remaining time for the
/// current story. Users may tap the left or right side of the view to manually
/// rewind or advance, and accessibility buttons are available for VoiceOver
/// users.
///
/// **Usage**
///
/// ```swift
/// struct Colorful {
///     let id: Int
///     let color: Color
/// }
///
/// let data = [
///     Colorful(id: 1, color: .red),
///     Colorful(id: 2, color: .white),
///     Colorful(id: 3, color: .blue)
/// ]
///
/// StoryView(cycle: .once, data: data) { data in
///     Text("Page #\(data.id)")
/// } background: { data in
///     data.color
/// }
/// .onCycleComplete { remaining in
///     print("Cycles remaining: \(remaining)")
/// }
/// .storyProgressIndicatorTint(.indigo.gradient)
/// .storyProgressIndicatorInsets(EdgeInsets(.horizontal, 16))
/// ```
public struct StoryView<Data, Content: View, Background: View>: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.theme) private var theme
    @Environment(\.storyProgressIndicatorInsets) private var insets
    @State private var storyTimer: StoryTimer
    private let pauseWhenInactive: Bool
    private let data: [Data]
    private let content: (Data) -> Content
    private let background: (Data) -> Background

    public var body: some View {
        ZStack(alignment: .top) {
            // Get the data for current page based on the story timer's progress.
            let data = data[Int(storyTimer.progress)]

            // Render the background if provided.
            if Background.self != Never.self {
                background(data)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            }

            // Display tap zones for advancing or rewinding stories.
            advanceButtons()

            // Render the main story content.
            content(data)
                .frame(maxWidth: .infinity)

            // Display the progress indicator at the top.
            progressIndicator
        }
        .onAppear(perform: storyTimer.start)
        .onDisappear(perform: storyTimer.stop)
        .applyIf(pauseWhenInactive) {
            $0.onChange(of: scenePhase) { _, phase in
                switch phase {
                    case .active:
                        storyTimer.resume()
                    case .inactive:
                        storyTimer.pause()
                    default:
                        break
                }
            }
        }
    }

    /// A view that displays the horizontal progress indicator.
    private var progressIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<data.count, id: \.self) { index in
                StoryProgressIndicator(value: storyTimer.progress(for: index))
            }
        }
        .padding(insets)
        .accessibilityHidden(true)
    }

    /// A closure invoked on every cycle completion.
    ///
    /// - Parameter callback: The block to execute with a parameter indicating
    ///   remaining number of cycles.
    public func onCycleComplete(
        _ callback: @escaping (_ remainingCycles: Count<UInt>) -> Void
    ) -> Self {
        storyTimer.onCycleComplete = callback
        return self
    }
}

// MARK: - Advancing Page

extension StoryView {
    /// Returns a view that provides tap zones to advance or rewind a page in the
    /// story.
    @ViewBuilder
    private func advanceButtons() -> some View {
        accessibilityAdvanceButtons()

        HStack(spacing: 0) {
            advanceButton(isLeft: true)
            advanceButton(isLeft: false)
        }
        .ignoresSafeArea()
    }

    /// Returns a tappable area that advances or rewinds a page in the story.
    private func advanceButton(isLeft: Bool) -> some View {
        Rectangle()
            .foregroundStyle(.clear)
            .contentShape(.rect)
            .onTapGesture {
                storyTimer.advance(by: isLeft ? -1 : 1)
            }
            .onLongPressGesture(minimumDuration: 10, maximumDistance: .greatestFiniteMagnitude) {
                storyTimer.pause()
            } onPressingChanged: { isPressing in
                isPressing ? storyTimer.pause() : storyTimer.resume()
            }
    }

    /// Provides accessibility buttons for advancing or rewinding a page in the
    /// story when VoiceOver is enabled.
    @ViewBuilder
    private func accessibilityAdvanceButtons() -> some View {
        if UIAccessibility.isVoiceOverRunning {
            HStack {
                accessibilityAdvanceButton(isLeft: true)
                Spacer()
                accessibilityAdvanceButton(isLeft: false)
            }
            .padding(.defaultSpacing)
            .frame(alignment: .center)
        }
    }

    /// Returns an accessibility button for navigation.
    private func accessibilityAdvanceButton(isLeft: Bool) -> some View {
        VStack {
            Spacer()
            Image(system: isLeft ? .arrowLeftCircleFill : .arrowRightCircleFill)
                .resizable()
                .frame(36)
                .foregroundStyle(theme.backgroundColor)
                .onTap {
                    storyTimer.advance(by: isLeft ? -1 : 1)
                    UIAccessibility.post(notification: .screenChanged, argument: nil)
                    storyTimer.resume()
                }
                .accessibilityLabel(isLeft ? "Previous page" : "Next page")
            Spacer()
        }
    }
}

// MARK: - Inits

extension StoryView {
    /// Creates a new `StoryView`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct Colorful {
    ///     let id: Int
    ///     let color: Color
    /// }
    ///
    /// let data = [
    ///     Colorful(id: 1, color: .red),
    ///     Colorful(id: 2, color: .white),
    ///     Colorful(id: 3, color: .blue)
    /// ]
    ///
    /// StoryView(cycle: .once, data: data) { data in
    ///     Text("Page #\(data.id)")
    /// } background: { data in
    ///     data.color
    /// }
    /// .onCycleComplete { remaining in
    ///     print("Cycles remaining: \(remaining)")
    /// }
    /// .storyProgressIndicatorTint(.indigo.gradient)
    /// .storyProgressIndicatorInsets(EdgeInsets(.horizontal, 16))
    /// ```
    ///
    /// - Parameters:
    ///   - duration: The duration each page in the story is displayed.
    ///   - cycle: The number of cycles, or `.infinite` for continuous looping.
    ///   - data: An array of data that's useed to build content and background
    ///     views.
    ///   - pauseWhenInactive: A Boolean property indicating whether the view pauses
    ///     when the app becomes inactive.
    ///   - content: A view that describes the page content.
    ///   - background: A view that describes the page background.
    public init(
        duration: Duration = .seconds(4),
        cycle: Count<UInt> = .infinite,
        data: [Data],
        pauseWhenInactive: Bool = true,
        @ViewBuilder content: @escaping (Data) -> Content,
        @ViewBuilder background: @escaping (Data) -> Background
    ) {
        self.storyTimer = StoryTimer(
            pagesCount: data.count,
            duration: duration,
            cycle: cycle
        )
        self.data = data
        self.pauseWhenInactive = pauseWhenInactive
        self.content = content
        self.background = background
    }
}

extension StoryView where Background == Never {
    /// Creates a new `StoryView`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// struct Colorful {
    ///     let id: Int
    ///     let color: Color
    /// }
    ///
    /// let data = [
    ///     Colorful(id: 1, color: .red),
    ///     Colorful(id: 2, color: .white),
    ///     Colorful(id: 3, color: .blue)
    /// ]
    ///
    /// StoryView(cycle: .once, data: data) { data in
    ///     Text("Page #\(data.id)")
    ///         .foregroundStyle(data.color)
    /// }
    /// .onCycleComplete { remaining in
    ///     print("Cycles remaining: \(remaining)")
    /// }
    /// .storyProgressIndicatorTint(.indigo.gradient)
    /// .storyProgressIndicatorInsets(EdgeInsets(.horizontal, 16))
    /// ```
    ///
    /// - Parameters:
    ///   - duration: The duration each page in the story is displayed.
    ///   - cycle: The number of cycles, or `.infinite` for continuous looping.
    ///   - data: An array of data that's useed to build content views.
    ///   - pauseWhenInactive: A Boolean property indicating whether the view pauses
    ///     when the app becomes inactive.
    ///   - content: A view that describes the page content.
    public init(
        duration: Duration = .seconds(4),
        cycle: Count<UInt> = .infinite,
        data: [Data],
        pauseWhenInactive: Bool = true,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.init(
            duration: duration,
            cycle: cycle,
            data: data,
            pauseWhenInactive: pauseWhenInactive,
            content: content,
            background: { _ in fatalError() }
        )
    }
}

// MARK: - Preview

#Preview {
    struct Colorful: Identifiable {
        let id: Int
        let color: Color
    }

    let data = [
        Colorful(id: 1, color: .green),
        Colorful(id: 2, color: .blue),
        Colorful(id: 3, color: .purple)
    ]

    return StoryView(cycle: .once, data: data) { data in
        VStack {
            Text("Page")
            Text("#")
                .baselineOffset(70)
                .font(.system(size: 100)) +
            Text("\(data.id)")
                .font(.system(size: 200))
        }
        .frame(max: .infinity)
    } background: { data in
        data.color
    }
    .onCycleComplete { remaining in
        print("Cycles remaining: \(remaining)")
    }
}
