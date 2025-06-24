import SwiftUI

struct ContentView: View {
    @State private var apiService = APIService()

    var body: some View {
        SplashScreenView()
    }

}

#Preview {
    ContentView()
}
