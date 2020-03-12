//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension ExampleTextViewController {
    private enum Segment: Int, CaseIterable {
        case excerpt
        case markdown

        var title: String {
            "\(self)".uppercasedFirst()
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
