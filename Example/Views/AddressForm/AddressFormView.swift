//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import ComposableArchitecture

enum Localized {
    enum AddressForm {
        static let add = "I don’t see my address"
        static let navigationTitle = "Update Address"
        static let searchPlaceholder = "Enter your address"
        enum Key {
            static let city = "City"
            static let country = "Country"
            static let postalCode = "ZIP"
            static let state = "State"
            static let street1 = "Street"
            static let street2 = "APT, Unit#"
        }
    }
}

// MARK: - Convenience Inits

extension AddressFormView<AnyView, Never> {
    /// Initializes an `AddressFormView` using a store of `AddressForm` state.
    ///
    /// This initializer converts the provided content to `AnyView` and does not
    /// provide a footer.
    ///
    /// - Parameter store: The store holding `AddressForm` state.
    public init(store: StoreOf<AddressForm>) {
        self.init(store: store) { content in
            content.eraseToAnyView()
        } footer: {
            fatalError()
        }
    }
}

extension AddressFormView where Footer == Never {
    /// Initializes an `AddressFormView` with a confirmation closure and no footer.
    ///
    /// - Parameters:
    ///   - store: The store holding `AddressForm` state.
    ///   - confirmation: A closure that transforms a view into confirmed content.
    public init(store: StoreOf<AddressForm>,
                confirmation: @escaping (any View) -> Content) {
        self.init(store: store, confirmation: confirmation) {
            fatalError()
        }
    }
}

// MARK: - AddressFormView

/// A SwiftUI view that provides an address input form.
///
/// This view allows users to search for an address, select a result, manually
/// edit address details, and confirm their selection. It integrates with
/// Composable Architecture for state management and supports error handling.
///
/// **Usage**
///
/// ```swift
/// let store = Store(
///     initialState: .init(navigationTitle: "Enter Address"),
///     reducer: {
///         AddressForm()
///     }
/// )
/// AddressFormView(store: store)
/// ```
public struct AddressFormView<Content: View, Footer: View>: View {
    private typealias L = Localized.AddressForm
    @Environment(\.theme) private var theme
    @Environment(\.font) private var font
    @Bindable private var store: StoreOf<AddressForm>
    private let footer: () -> Footer
    private let confirmation: (any View) -> Content
    @FocusState private var isTextFieldFocused: Bool

    /// Creates an `AddressFormView` with a store, confirmation closure, and footer.
    ///
    /// - Parameters:
    ///   - store: The `StoreOf<AddressForm>` that manages the state.
    ///   - confirmation: A closure that builds the confirmation view.
    ///   - footer: A view builder for footer content (typically used for extra actions).
    public init(
        store: StoreOf<AddressForm>,
        confirmation: @escaping (any View) -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.store = store
        self.footer = footer
        self.confirmation = confirmation
    }

    public var body: some View {
        VStack(spacing: 0) {
            DynamicTextField(
                L.searchPlaceholder,
                value: $store.search,
                configuration: .address(component: .street)
            )
            .dynamicTextFieldStyle(.primary)
            .submitLabel(.continue)
            .focused($isTextFieldFocused)
            .isLoading(store.searchResults.isLoading)
            .padding(.horizontal)
            .onSubmit {
                store.send(.searchButtonTapped)
            }

            searchResultsView
        }
        .navigationTitle(store.navigationTitle)
        .onLoad {
            $store.isEditingAddress.wrappedValue = false
        }
        .onAppear {
            isTextFieldFocused = true
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
        .navigationDestination(isPresented: $store.isEditingAddress) {
            confirmation(addressEditView)
        }
    }

    /// Displays search results and an option to manually add an address.
    private var searchResultsView: some View {
        List {
            switch store.searchResults {
                case let .success(results):
                    ForEach(results, id: \.self) { result in
                        Button {
                            store.send(.searchResultTapped(result))
                        } label: {
                            VStack(alignment: .leading, spacing: .s1) {
                                Text(result.title)
                                Text(result.subtitle)
                                    .font(.app(.footnote))
                                    .foregroundStyle(theme.textSecondaryColor)
                            }
                        }
                        .listRowStyle(separator: .lineInset)
                    }
                case .failure:
                    VStack {
                        ContentUnavailableView.search(text: store.search)
                    }
                    .listRowStyle()
                case .idle, .loading:
                    EmptyView()
            }

            VStack(spacing: .defaultSpacing) {
                if !store.search.isBlank {
                    Button(L.add, systemImage: "plus") {
                        store.send(.addressNotFoundTapped)
                    }
                }

                if Footer.self != Never.self {
                    Separator()
                    footer()
                }
            }
            .listRowStyle(separator: .hidden)
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }

    /// A view that allows users to edit their selected address.
    ///
    /// This form provides input fields for street, city, state, ZIP, and country.
    /// It also includes pickers for selecting a state or country, ensuring a smooth
    /// user experience.
    private var addressEditView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack {
                        DynamicTextField(L.Key.street1, value: $store.address.street1, configuration: .address(component: .street1))
                        DynamicTextField(L.Key.street2, value: $store.address.street2, configuration: .address(component: .street2))
                        DynamicTextField(L.Key.city, value: $store.address.city, configuration: .address(component: .city))
                        HStack {
                            PickerButton(store.address.state, placeholder: L.Key.state) {
                                $store.isStatePickerPresented.wrappedValue = true
                            }

                            DynamicTextField(L.Key.postalCode, value: $store.address.postalCode, configuration: .address(component: .postalCode))
                        }

                        PickerButton(store.address.country, placeholder: L.Key.country) {
                            $store.isCountryPickerPresented.wrappedValue = true
                        }
                    }
                    .overlayLoader(store.address.isEmpty)
                    .defaultButtonFont(font)

                    Spacer()

                    Button.continue {
                        store.send(.addressConfirmedButtonTapped)
                    }
                    .buttonStyle(.primary)
                    .disabled(!store.address.isComplete)
                    .isLoading(store.isPerformingRequest)
                }
                .padding(.horizontal, .defaultSpacing)
                .deviceSpecificBottomPadding()
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea(.keyboard)
        .scrollDismissesKeyboard(.immediately)
        .dynamicTextFieldStyle(.primary)
        .navigationTitle(store.navigationTitle)
        .popup($store.lookupError)
        .popup($store.validationError)
        .sheet(isPresented: $store.isCountryPickerPresented) {
            AddressFormPicker(selection: $store.address.countryCode) {
                ForEach([""] + PostalAddress.countryCodes, id: \.self) { code in
                    Text(PostalAddress.countryName(isoCode: code) ?? "")
                }
            }
        }
        .sheet(isPresented: $store.isStatePickerPresented) {
            AddressFormPicker(selection: $store.address.state) {
                ForEach([""] + PostalAddress.stateCodes, id: \.self) { code in
                    Text(PostalAddress.stateName(code: code) ?? "")
                }
            }
        }
    }

    /// A customizable button that presents a picker when tapped.
    ///
    /// This button displays a selected value if available; otherwise, it shows a
    /// placeholder with a distinct style. The button expands to fill the available
    /// width and aligns its content to the leading edge.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// PickerButton("California", placeholder: "Select State") {
    ///     showStatePicker = true
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The currently selected value. If empty, the placeholder is shown.
    ///   - placeholder: A fallback text displayed when `title` is empty.
    ///   - action: A closure executed when the button is tapped.
    private func PickerButton(
        _ title: String,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title.isBlank ? placeholder : title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle {
                    title.isBlank ? theme.placeholderTextColor : nil
                }
        }
        .buttonStyle(.secondary)
    }
}

// MARK: - Picker

private struct AddressFormPicker<SelectionValue: Hashable, Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    private let selection: Binding<SelectionValue>
    private let content: () -> Content

    init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.selection = selection
        self.content = content
    }

    var body: some View {
        VStack {
            Picker("", selection: selection, content: content)
                .pickerStyle(.wheel)

            Button.done {
                dismiss()
            }
            .buttonStyle(.primary)
        }
        .presentationDetents(.contentHeight)
    }
}

// MARK: - Preview

#Preview {
    AddressFormView(store: .init(
        initialState: .init(navigationTitle: "Address"),
        reducer: { AddressForm() }
    ))
}
