//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import SwiftUI

private struct PopupPreviews: View {
    private let L = Samples.Strings.locationAlert
    @Environment(\.theme) private var theme
    @State private var showSystemAlert = false
    @State private var showAlert = false
    @State private var showAlertWithHeader = false
    @State private var showToast = false
    @State private var showWindow = false

    var body: some View {
        List {
            row(
                "Show System Alert",
                color: .blue,
                image: .appleLogo,
                toggle: $showSystemAlert
            )

            row(
                "Show Alert",
                color: .indigo,
                image: .number1Circle,
                toggle: $showAlert
            )

            row(
                "Show Alert with Header",
                color: .indigo,
                image: .number1Circle,
                toggle: $showAlertWithHeader
            )

            ShowPartDetail()

            row(
                "Show Toast",
                color: .green,
                image: .number3Circle,
                toggle: $showToast
            )

            row(
                "Show Window",
                color: .green,
                image: .macWindow,
                toggle: $showWindow
            )

            OpenMailAppButton()
        }
        .navigationTitle("Popups")
        .alert(L.title, isPresented: $showSystemAlert) {
            Button.okay {
                showSystemAlert = false
            }
        } message: {
            Text(L.message)
        }
        .popup(L.title, message: L.message, isPresented: $showAlert, dismissMethods: [.xmark, .tapOutside]) {
            Button.okay {
                showAlert = false
            }
            .buttonStyle(.rectFill)
        }
        .popup(isPresented: $showAlertWithHeader) {
            StandardPopupAlertContent(Text(L.title), message: Text(L.message)) {
                Image(system: .locationSlashFill)
                    .symbolEffect(.variableColor)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .blue.opacity(0.5).gradient)
                    .font(.largeTitle)
            } footer: {
                Button.okay {
                    showAlertWithHeader = false
                }
                .buttonStyle(.rectFill)
            }
        }
        .popup(isPresented: $showToast, style: .toast) {
            CapsuleView("Sam’s AirPods", subtitle: "Connected", systemImage: .airpods)
        }
        .window(isPresented: $showWindow) {
            Button {
                showWindow = false
            } label: {
                CapsuleView("Tap to Hide Window", systemImage: .macWindow)
                    .foregroundStyle(.indigo)
            }
            .frame(height: 300)
            .padding(.s8)
            .background(.background.tertiary)
            .cornerRadius(AppConstants.cornerRadius)
            .floatingShadow()
        }
    }

    private func row(_ title: String, color: Color, image: SystemAssetIdentifier, toggle: Binding<Bool>) -> some View {
        Button {
            toggle.wrappedValue = true
        } label: {
            Label(title, systemImage: image)
                .labelStyle(.settingsIcon(tint: color))
        }
    }
}

// MARK: - Preview

#Preview {
    PopupPreviews()
        .embedInNavigation()
}

extension Samples {
    public static var popupPreviews: some View {
        PopupPreviews()
    }
}

private struct ShowPartDetail: View {
    @State private var popupDetail: InventoryItem?

    var body: some View {
        Button("Show Part Details") {
            popupDetail = InventoryItem(
                id: "0123456789",
                partNumber: "Z-1234A",
                quantity: 100,
                name: "Widget"
            )
        }
        .popup(item: $popupDetail) { detail in
            VStack(alignment: .leading, spacing: 20) {
                Text("Part Number: \(detail.partNumber)")
                Text("Name: \(detail.name)")
                Text("Quantity On-Hand: \(detail.quantity)")
            }
            .contentShape(.rect)
            .onTapGesture {
                popupDetail = nil
            }
        }
    }
}

private struct InventoryItem: Hashable, Identifiable {
    var id: String
    let partNumber: String
    let quantity: Int
    let name: String
}
#endif
