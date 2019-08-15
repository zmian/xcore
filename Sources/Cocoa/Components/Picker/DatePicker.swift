//
// DatePicker.swift
//
// Copyright © 2019 Xcore
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

import Foundation

final public class DatePicker: DrawerScreen.Content, With {
    private var initialDate: Date?
    private var didChangeValue: ((Date?) -> Void)?

    public var drawerContentView: UIView {
        return stackView
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [
        toolbar,
        pickerView
    ]).apply {
        $0.axis = .vertical
    }

    private lazy var toolbar = InputToolbar().apply {
        $0.backgroundColor = .clear
        $0.didTapDone { [weak self] in
            DrawerScreen.dismiss()
        }

        $0.didTapCancel { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didChangeValue?(strongSelf.initialDate)
            DrawerScreen.dismiss()
        }
    }

    private lazy var pickerView = UIDatePicker().apply {
        $0.datePickerMode = .date
        $0.backgroundColor = .clear
        $0.addAction(.valueChanged) { [weak self] sender in
            self?.didChangeValue?(sender.date)
        }
    }

    public static func present(
        initialValue date: Date? = nil,
        style: XCConfiguration<UIDatePicker>? = nil,
        _ callback: @escaping (Date?) -> Void
    ) {
        let picker = DatePicker().apply {
            $0.initialDate = date
            $0.pickerView.date = date ?? Date()
            $0.didChangeValue = callback
            if let style = style {
                $0.pickerView.apply(style: style)
            }
        }

        DrawerScreen.present(picker)
    }
}
