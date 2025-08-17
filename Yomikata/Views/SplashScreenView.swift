import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var loadingProgress = 0.0

    @State private var showAuth = false

    // Color del logo (aproximado)
    private let brandColor = Color(
        red: 246 / 255, green: 86 / 255, blue: 54 / 255)  // #f65636

    var body: some View {
        if isLoading {
            ZStack {
                brandColor.ignoresSafeArea()
                VStack(spacing: 4) {
                    Image("yomikata-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)

                    VStack(spacing: 8) {
                        Text("YOMIKATA")
                            .font(
                                .system(
                                    size: 38, weight: .bold, design: .monospaced
                                )
                            )
                            .foregroundColor(.white)
                            .opacity(logoOpacity)

                        Text("読み方")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(logoOpacity)
                    }

                    VStack(spacing: 12) {
                        ProgressView().tint(.white).scaleEffect(1.2)
                        Text("loading.initial".localized())
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .opacity(logoOpacity)
                    .padding(.top, 24)
                }
            }
            .onAppear { startAnimations() }
            .task { await loadInitialData() }
        } else {
            MainTabView()
                // Muestra AuthView por encima si no hay token
                .fullScreenCover(isPresented: $showAuth) {
                    AuthView {
                        showAuth = false  // se oculta al autenticar
                    }
                }
                .transition(.opacity.combined(with: .scale))
        }
    }

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
    }

    private func loadInitialData() async {
        // Renueva token mientras se muestra el splash (~2s)
        async let renewTask: Bool = APIService().renewTokenIfNeeded()
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        _ = await renewTask  // esperamos la renovación (ignoramos el Bool)

        // Si el renew limpió por 401, exists() será false -> mostramos login
        let hasToken = await AuthTokenStore.shared.exists()

        withAnimation(.easeInOut(duration: 0.5)) {
            isLoading = false
            showAuth = !hasToken
        }
    }

}

#Preview { SplashScreenView() }
