//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class ExamplePickerListModel: PickerListModel {
    private var timer: Timer?
    private var count = 0

    var items: [DynamicTableModel] {
        [
            .init(title: "Option 1", subtitle: "List has been shown for \(count) second(s)"),
            .init(title: "Option 1", subtitle: "PickerList demonstration")
        ]
    }

    private var didChange: (() -> Void)?
    func didChange(_ callback: @escaping () -> Void) {
        didChange = callback
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
        didChange?()
    }
}
