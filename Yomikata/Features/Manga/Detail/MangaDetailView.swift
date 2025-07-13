import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @State private var viewModel = MangaDetailViewModel()
    @State private var showAddSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header SIN padding - va edge to edge
                MangaDetailHeader(manga: manga)

                // Resto del contenido CON padding
                VStack(alignment: .leading, spacing: 20) {
                    MangaDetailInfo(manga: manga)
                    MangaDetailSynopsis(manga: manga)
                    MangaDetailCategories(manga: manga)
                    Spacer(minLength: 100)
                }
                .padding()  // Solo el contenido de abajo tiene padding
            }
        }
        .ignoresSafeArea(.container, edges: .top)  // Para que el header vaya hasta arriba
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
            ) { ownedVolumes, readingVolume, isComplete in
                Task {
                    await viewModel.addToCollection(
                        manga: manga,
                        volumesOwned: ownedVolumes,
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
