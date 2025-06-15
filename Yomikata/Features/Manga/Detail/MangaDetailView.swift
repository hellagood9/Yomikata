import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @State private var viewModel = MangaDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                MangaDetailHeader(manga: manga)
                MangaDetailInfo(manga: manga)
                MangaDetailSynopsis(manga: manga)
                MangaDetailCategories(manga: manga)
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                BookmarkButton(
                    isBookmarked: viewModel.isInCollection,
                    action: {
                        Task {
                            await viewModel.toggleCollection(for: manga)
                        }
                    }
                )
            }
        }
        .task {
            viewModel.checkCollectionStatus(for: manga)
        }
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(manga: .preview)
    }
}
