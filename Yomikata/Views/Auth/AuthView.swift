import SwiftUI

struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AuthViewModel()
    @FocusState private var focused: Field?

    let onAuthenticated: @MainActor () -> Void

    private enum Field: Hashable { case email, password }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("", selection: $vm.mode) {
                        ForEach(AuthViewModel.Mode.allCases, id: \.self) { m in
                            Text(m.localizedTitle).tag(m)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowInsets(
                    .init(top: 6, leading: 16, bottom: -2, trailing: 16)
                )
                .listRowBackground(Color.clear)

                Section {
                    TextField("auth.email".localized(), text: $vm.email)
                        .textInputAutocapitalization(.never)
                        .textContentType(.username)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .focused($focused, equals: .email)

                    SecureField("auth.password".localized(), text: $vm.password)
                        .textContentType(.password)
                        .focused($focused, equals: .password)
                }
                .disabled(vm.isBusy)

                if let error = vm.error {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
                Section {
                    let title =
                        vm.mode == .login
                        ? "auth.button.login".localized()
                        : "auth.button.register".localized()

                    Button {
                        vm.submit {
                            onAuthenticated()
                            dismiss()
                        }
                    } label: {
                        Text(title)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .disabled(!vm.isValid || vm.isBusy)
                    .overlay {
                        if vm.isBusy { ProgressView() }
                    }
                }
                .listRowInsets(
                    .init(top: 4, leading: 16, bottom: 4, trailing: 16)
                )
                .listRowBackground(Color.clear)

            }
            .scrollContentBackground(.hidden)  // quita el fondo gris del Form
            .background(Color.accentColor.opacity(0.1))
            .navigationTitle("auth.title".localized())
            .submitLabel(focused == .email ? .next : .go)
            .onSubmit {
                if focused == .email {
                    focused = .password
                } else {
                    vm.submit {
                        onAuthenticated()
                        dismiss()
                    }
                }
            }
        }
        .tint(Color.accentColor)
    }
}
