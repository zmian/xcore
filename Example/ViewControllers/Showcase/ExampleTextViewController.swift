//
// ExampleTextViewController.swift
//
// Copyright © 2019 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

extension ExampleTextViewController {
    private enum Segment: Int, CaseIterable {
        case excerpt
        case markdown

        var title: String {
            return "\(self)".capitalizeFirstCharacter
        }

        var filename: String {
            switch self {
                case .excerpt:
                    return "Excerpt.txt"
                case .markdown:
                    return "MarkdownAcidTest.txt"
            }
        }
    }
}

final class ExampleTextViewController: TextViewController {
    private let segmentedControl = UISegmentedControl(items: Segment.allCases.map { $0.title })

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TextViewController"
        setupSegmentedControl()
        contentInset = UIEdgeInsets(
            top: .maximumPadding + 58,
            left: .maximumPadding,
            bottom: .maximumPadding,
            right: .maximumPadding
        )

        setText(for: .excerpt)
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupSegmentedControl() {
        let blurView = BlurView()
        view.addSubview(blurView)
        blurView.addSubview(segmentedControl)

        blurView.snp.makeConstraints {
            $0.top.equalToSuperviewSafeArea()
            $0.leading.trailing.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperviewSafeArea().inset(.defaultPadding)
        }

        segmentedControl.addAction(.valueChanged) { [weak self] in
            guard let strongSelf = self else { return }
            let segment = Segment(rawValue: $0.selectedSegmentIndex)!
            strongSelf.setText(for: segment)
        }
    }

    private func setText(for segment: Segment) {
        setText(segment.filename)
    }
}
