//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class ExampleTextViewController: TextViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TextViewController"

        contentInset = UIEdgeInsets(
            top: .maximumPadding + 58,
            left: .maximumPadding,
            bottom: .maximumPadding,
            right: .maximumPadding
        )

        setText("Excerpt.txt") { string in
            NSMutableAttributedString(string: string)
                .link(
                    url: URL(string: "https://theculturetrip.com/middle-east/articles/the-top-10-stories-from-1001-nights")!,
                    text: "Source ▸"
                )
                .foregroundColor(.label)
        }
    }
}
