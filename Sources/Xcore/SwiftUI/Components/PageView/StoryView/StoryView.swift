//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct StoryView<Page, Content, Background>: View where Page: Identifiable, Content: View, Background: View {
    @Environment(\.storyProgressIndicatorInsets) private var insets
    @Environment(\.theme) private var theme
    @Dependency(\.appPhase) private var appPhase
    @StateObject private var storyTimer: StoryTimer
    private let pages: [Page]
    private let pauseWhenInactive: Bool
    private let content: (Page) -> Content
    private let background: (Page) -> Background

    public var body: some View {
        ZStack(alignment: .top) {
            let page = pages[Int(storyTimer.progress)]

            // Background
            if Background.self != Never.self {
                background(page)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            }

            // Tap to advance or rewind
            advanceButtons()

            // Content
            content(page)
                .frame(maxWidth: .infinity)

            // Progress Indicator
            progressIndicator
        }
        .onAppear(perform: storyTimer.start)
        .onDisappear(perform: storyTimer.stop)
        .applyIf(pauseWhenInactive) {
            $0.onReceive(appPhase.receive) { phase in
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

    private var progressIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<pages.count, id: \.self) { index in
                StoryProgressIndicator(progress: storyTimer.progress(for: index))
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
        _ callback: @escaping (_ remainingCycles: Count) -> Void
    ) -> Self {
        storyTimer.onCycleComplete = callback
        return self
    }
}

// MARK: - Advancing Page

extension StoryView {
    /// Tap left and right edges to rewind or advance a page.
    @ViewBuilder
    private func advanceButtons() -> some View {
        accessibilityAdvanceButtons()

        HStack(spacing: 0) {
            advanceButton(isLeft: true)
            advanceButton(isLeft: false)
        }
        .ignoresSafeArea()
    }

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
                if isPressing {
                    storyTimer.pause()
                } else {
                    storyTimer.resume()
                }
            }
    }
}

// MARK: - Accessibility Buttons

extension StoryView {
    /// Adds left and right buttons to rewind or advance a page when VoiceOver is
    /// enabled. Following the Instagram approach of navigating stories during
    /// VoiceOver.
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
    public init(
        interval: TimeInterval = 4,
        cycle: Count = .infinite,
        pages: [Page],
        pauseWhenInactive: Bool = false,
        @ViewBuilder content: @escaping (Page) -> Content,
        @ViewBuilder background: @escaping (Page) -> Background
    ) {
        self._storyTimer = .init(wrappedValue: .init(
            pagesCount: pages.count,
            interval: interval,
            cycle: cycle
        ))
        self.pages = pages
        self.pauseWhenInactive = pauseWhenInactive
        self.content = content
        self.background = background
    }
}

// MARK: - Preview

#Preview {
    struct Colorful: Identifiable {
        let id: Int
        let color: Color
    }

    let pages = [
        Colorful(id: 1, color: .green),
        Colorful(id: 2, color: .blue),
        Colorful(id: 3, color: .purple)
    ]

    return StoryView(cycle: .once, pages: pages) { page in
        VStack {
            Text("Page")
            Text("#")
                .baselineOffset(70)
                .font(.system(size: 100)) +
            Text("\(page.id)")
                .font(.system(size: 200))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } background: { page in
        page.color
    }
    .onCycleComplete { count in
        print(count)
    }
}
