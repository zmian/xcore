//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class ExamplePickerListModel: PickerListModel {
    private var timer: Timer?
    private var count = 0
    private var _didChange: (() -> Void)?

    var items: [DynamicTableModel] {
        [
            .init(title: "Option 1", subtitle: "List has been shown for \(count) second(s)"),
            .init(title: "Option 1", subtitle: "PickerList demonstration")
        ]
    }

    func didChange(_ callback: @escaping () -> Void) {
        _didChange = callback
    }

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateCount()
        }
    }

    deinit {
        timer?.invalidate()
    }

    private func updateCount() {
        count += 1
        _didChange?()
    }
}
