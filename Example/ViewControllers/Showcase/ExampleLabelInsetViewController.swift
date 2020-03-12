//
//  ExampleLabelInsetViewController.swift
//  Example
//
//  Created by Guillermo Waitzel on 12/03/2020.
//  Copyright © 2020 Xcore. All rights reserved.
//

import Foundation

final class ExampleLabelInsetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UILabel + ContentInset"
        view.backgroundColor = .white
        setupContentView()
    }

    private func setupContentView() {
        let label = UILabel().apply {
            $0.text = "This has horizontal inset"
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
        }
        let label2 = UILabel().apply {
            $0.text = "This has horizontal and vertical inset."
            $0.contentInset = .maximumPadding
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
        }
        let label3 = UILabel().apply {
            $0.text = "100w constrained."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
        }
        let label4 = UILabel().apply {
            $0.text = "This is label is 100h 100w constrained."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
        }
        let label5 = UILabel().apply {
            $0.text = "This is label is constrained to 300h 150w."
            $0.contentInset = UIEdgeInsets(horizontal: .maximumPadding)
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
        }
        let stackView = UIStackView(arrangedSubviews: [
            label,
            label2,
            label3,
            label4,
            label5
        ]).apply {
            $0.axis = .vertical
            $0.alignment = .center
            $0.backgroundColor = .blue
            $0.spacing = 10
        }

        label3.snp.makeConstraints { make in
            make.width.equalTo(100.0)
        }

        label4.snp.makeConstraints { make in
            make.size.equalTo(100.0)
        }
        label5.snp.makeConstraints { make in
            make.height.equalTo(300.0)
            make.width.equalTo(150.0)
        }

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperviewSafeArea().inset(.maximumPadding)
            $0.centerY.equalToSuperviewSafeArea()
        }
    }
}
