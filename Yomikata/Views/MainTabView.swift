import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MangaListView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("tabs.mangas".localized(fallback: "Mangas"))
                        .foregroundColor(.accentColor)
                }

            RemoteCollectionView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("tabs.collection".localized(fallback: "Collection"))
                        .foregroundColor(.accentColor)
                }
        }
    }
}

#Preview {
    MainTabView()
}
