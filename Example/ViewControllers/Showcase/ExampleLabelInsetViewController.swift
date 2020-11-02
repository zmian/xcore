//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ExampleLabelInsetViewController {
    private enum Constants {
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 13
    }
}

final class ExampleLabelInsetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UILabel + ContentInset"
        view.backgroundColor = .systemBackground
        setupContentView()
    }

    private func setupContentView() {
        let label = UILabel().apply {
            $0.text = "This has horizontal inset"
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .tertiarySystemBackground
            $0.numberOfLines = 0
        }
        let label2 = UILabel().apply {
            $0.text = "This has horizontal and vertical inset."
            $0.contentInset = .maximumPadding
            $0.backgroundColor = .tertiarySystemBackground
            $0.numberOfLines = 0
        }
        let label3 = UILabel().apply {
            $0.text = "100w constrained."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .tertiarySystemBackground
            $0.numberOfLines = 0
        }
        let label4 = UILabel().apply {
            $0.text = "100h 100w constrained."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .tertiarySystemBackground
            $0.numberOfLines = 0
        }
        let label5 = UILabel().apply {
            $0.text = "This is label is constrained to 200h 150w."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .tertiarySystemBackground
            $0.numberOfLines = 0
        }
        let stackView = UIStackView(arrangedSubviews: [
            SpacerView(height: Constants.padding),
            label,
            label2,
            label3,
            label4,
            label5,
            SpacerView(height: Constants.padding)
        ]).apply {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = Constants.padding
            $0.backgroundColor = .secondarySystemBackground
            $0.borderColor = .quaternarySystemFill
            $0.borderWidth = 1
            $0.roundCorners(.all, radius: Constants.cornerRadius)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            label3.widthAnchor.constraint(equalToConstant: 100),
            label4.widthAnchor.constraint(equalToConstant: 100),
            label4.heightAnchor.constraint(equalToConstant: 100),
            label5.widthAnchor.constraint(equalToConstant: 150),
            label5.heightAnchor.constraint(equalToConstant: 200)
        ])

        [label3, label4, label5].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .maximumPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.maximumPadding),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
