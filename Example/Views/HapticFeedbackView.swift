//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct HapticFeedbackView: View {
    @Dependency(\.hapticFeedback) private var hapticFeedback

    var body: some View {
        List {
            Section {
                Button("Selection Changed") {
                    hapticFeedback(.selection)
                }
            } header: {
                Text("Selection Feedback")
            } footer: {
                Text("Creates haptics to indicate a change in selection.")
            }

            Section {
                Button("Light Impact") {
                    hapticFeedback(.impact(.light))
                }

                Button("Medium Impact") {
                    hapticFeedback(.impact(.medium))
                }

                Button("Heavy Impact") {
                    hapticFeedback(.impact(.heavy))
                }

                Button("Soft Impact") {
                    hapticFeedback(.impact(.soft))
                }

                Button("Rigid Impact") {
                    hapticFeedback(.impact(.rigid))
                }
            } header: {
                Text("Impact Feedback")
            } footer: {
                Text("Creates haptics to simulate physical impacts with each style representing the mass of the colliding objects.")
            }

            Section {
                Button("Success") {
                    hapticFeedback(.notification(.success))
                }

                Button("Warning") {
                    hapticFeedback(.notification(.warning))
                }

                Button("Error") {
                    hapticFeedback(.notification(.error))
                }
            } header: {
                Text("Notification Feedback")
            } footer: {
                Text("Creates haptics to communicate successes, failures, and warnings.")
            }
        }
    }
}
