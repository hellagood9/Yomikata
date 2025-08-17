import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var mode: Mode = .login
    @Published var isBusy = false
    @Published var error: String?

    enum Mode: String, CaseIterable {
        case login = "Login"
        case register = "Registro"
    }
}

extension AuthViewModel {
    var isValid: Bool {
        email.contains("@") && email.contains(".") && password.count >= 8
    }

    func submit(onSuccess: @MainActor @escaping () -> Void) {
        guard isValid else {
            error = "auth.error.invalid_fields".localized(
                fallback: "Invalid email or password (min. 8 characters)."
            )
            return
        }

        let email = self.email
        let password = self.password
        let mode = self.mode

        isBusy = true

        Task {
            do {
                let api = APIService()
                let token: String

                if mode == .register {
                    try await api.registerUser(email: email, password: password)
                    token = try await api.loginUser(
                        email: email, password: password)
                } else {
                    token = try await api.loginUser(
                        email: email, password: password)
                }

                try await AuthTokenStore.shared.save(token)

                #if DEBUG
                    if let check = await AuthTokenStore.shared.load() {
                        print("🔑 TOKEN (prefix):", String(check.prefix(10)))
                    } else {
                        print("🔑 TOKEN no encontrado tras guardar")
                    }
                #endif

                await MainActor.run {
                    self.isBusy = false
                    self.error = nil
                    onSuccess()
                }
            } catch {
                await MainActor.run {
                    self.isBusy = false
                    self.error = error.localizedDescription
                }
            }
        }
    }
}

// Título localizable para el picker
extension AuthViewModel.Mode {
    var localizedTitle: String {
        switch self {
        case .login: return "auth.mode.login".localized()
        case .register: return "auth.mode.register".localized()
        }
    }
}
