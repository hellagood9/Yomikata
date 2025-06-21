import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @State private var viewModel = MangaDetailViewModel()
    @State private var showAddSheet = false
    
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
                        if viewModel.isInCollection {
                            Task {
                                await viewModel.removeFromCollection(manga)
                            }
                        } else {
                            showAddSheet = true
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddToCollectionSheet(
                manga: manga,
                isPresented: $showAddSheet
            ) { volumesPurchased, readingVolume, isComplete in
                Task {
                    await viewModel.addToCollection(
                        manga: manga,
                        volumesPurchased: volumesPurchased,
                        currentVolume: readingVolume,
                        isCompleteCollection: isComplete
                    )
                }
            }
        }
        .task {
            viewModel.checkCollectionStatus(for: manga)
        }
    }
}
