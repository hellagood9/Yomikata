import SwiftUI

struct ContentView: View {
    @State private var apiService = APIService()

    var body: some View {
        MainTabView()
    }

}

#Preview {
    ContentView()
}
