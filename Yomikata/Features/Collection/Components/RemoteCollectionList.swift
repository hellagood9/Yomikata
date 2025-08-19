import SwiftUI

struct RemoteCollectionList: View {
    @Bindable var viewModel: RemoteCollectionViewModel

    @State private var selectedManga: MangaCollection?

    private var stats: CollectionStats {
        CollectionStats(
            totalMangas: viewModel.collectionMangas.count,
            completedCollections: viewModel.collectionMangas.filter(
                \.completeCollection
            ).count,
            totalVolumesOwned: viewModel.collectionMangas.flatMap(
                \.volumesOwned
            ).count
        )
    }

    var body: some View {
        List {
            Section {
                CollectionStatsSection(stats: stats)
            }

            ForEach(viewModel.collectionMangas) { mangaCollection in
                CollectionMangaRow(
                    mangaCollection: mangaCollection,
                    onRemove: {
                        Task {
                            await viewModel.removeFromCollection(
                                mangaCollection)
                        }
                    },
                    onEdit: {
                        selectedManga = mangaCollection
                    }
                )
            }
            .onDelete(perform: deleteMangas)
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.regularMaterial)
            }
        }
        .sheet(item: $selectedManga) { manga in
            AddToCollectionSheet(
                manga: manga.manga,
                isPresented: Binding(
                    get: { selectedManga != nil },
                    set: { if !$0 { selectedManga = nil } }
                ),
                onSave: { ownedVolumes, readingVolume, complete in
                    Task {
                        await viewModel.updateCollection(
                            manga: manga.manga,
                            volumesOwned: ownedVolumes,
                            readingVolume: readingVolume,
                            completeCollection: complete
                        )
                    }
                },
                initialVolumes: manga.volumesOwned,
                initialReadingVolume: manga.readingVolume,
                initialComplete: manga.completeCollection
            )
        }
    }

    // MARK: - Actions
    private func deleteMangas(at offsets: IndexSet) {
        for index in offsets {
            let mangaCollection = viewModel.collectionMangas[index]
            Task {
                await viewModel.removeFromCollection(mangaCollection)
            }
        }
    }
}

#Preview {
    RemoteCollectionList(
        viewModel: {
            let viewModel = RemoteCollectionViewModel()
            viewModel.collectionMangas = [
                MangaCollection(
                    manga: .preview,
                    volumesOwned: Array(1...15),
                    readingVolume: 12,
                    completeCollection: false
                ),
                MangaCollection(
                    manga: .preview,
                    volumesOwned: Array(1...42),
                    readingVolume: 42,
                    completeCollection: true
                ),
            ]
            return viewModel
        }()
    )
}
