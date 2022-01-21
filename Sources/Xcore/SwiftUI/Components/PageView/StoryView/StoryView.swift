//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct StoryView<Page, Content, Background>: View where Page: Identifiable, Content: View, Background: View {
    @Environment(\.storyProgressIndicatorInsets) private var insets
    @Environment(\.theme) private var theme
    @ObservedObject private var storyTimer: StoryTimer
    private let pages: [Page]
    private let content: (Page) -> Content
    private let background: (Page) -> Background

    public var body: some View {
        ZStack(alignment: .top) {
            // Background
            if Background.self != Never.self {
                background(pages[Int(storyTimer.progress)])
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                    .animation(.none)
            }

            // Tap to advance or rewind for accessibility. Following the Instagram approach.
            HStack {
                accessibilityButton(isLeft: true)
                Spacer()
                accessibilityButton(isLeft: false)
            }
            .padding(.defaultSpacing)
            .frame(alignment: .center)

            // Tap to advance or rewind
            HStack(spacing: 0) {
                advanceView(isLeft: true)
                advanceView(isLeft: false)
            }
            .ignoresSafeArea()

            // Content
            content(pages[Int(storyTimer.progress)])
                .frame(maxWidth: .infinity)

            // Progress Indicator
            progressIndicator
        }
        .onAppear(perform: storyTimer.start)
        .onDisappear(perform: storyTimer.stop)
    }

    private var progressIndicator: some View {
        HStack(spacing: 4) {
            ForEach(pages.indices) { index in
                StoryProgressIndicator(progress: storyTimer.progress(for: index))
            }
            .accessibilityHidden(true)
        }
        .padding(insets)
    }

    @ViewBuilder
    private func accessibilityButton(isLeft: Bool) -> some View {
        if UIAccessibility.isVoiceOverRunning {
            VStack {
                Spacer()
                Image(system: isLeft ? .arrowLeftCircleFill : .arrowRightCircleFill)
                    .resizable()
                    .frame(36)
                    .foregroundColor(theme.backgroundColor)
                    .onTap {
                        storyTimer.advance(by: isLeft ? -1 : 1)
                        UIAccessibility.post(notification: .screenChanged, argument: nil)
                        storyTimer.resume()
                    }
                    .accessibilityLabel(isLeft ? "Previous story" : "Next story")
                Spacer()
            }
        }
    }

    private func advanceView(isLeft: Bool) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                storyTimer.advance(by: isLeft ? -1 : 1)
            }
            .onLongPressGesture(minimumDuration: 10, maximumDistance: 10) {
                storyTimer.pause()
            } onPressingChanged: { isPressing in
                if isPressing {
                    storyTimer.pause()
                } else {
                    storyTimer.resume()
                }
            }
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

// MARK: - Inits

extension StoryView {
    public init(
        interval: TimeInterval = 4,
        cycle: Count = .infinite,
        pages: [Page],
        @ViewBuilder content: @escaping (Page) -> Content,
        @ViewBuilder background: @escaping (Page) -> Background
    ) {
        self.storyTimer = .init(
            pagesCount: pages.count,
            interval: interval,
            cycle: cycle
        )
        self.pages = pages
        self.content = content
        self.background = background
    }
}

extension StoryView where Background == Never {
    public init(
        interval: TimeInterval = 4,
        cycle: Count = .infinite,
        pages: [Page],
        @ViewBuilder content: @escaping (Page) -> Content
    ) {
        self.init(
            interval: interval,
            cycle: cycle,
            pages: pages,
            content: content,
            background: { _ in fatalError() }
        )
    }
}

// MARK: - Previews

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
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
}
