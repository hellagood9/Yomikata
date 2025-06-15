import SwiftUI

struct CollectionList: View {
    @Bindable var viewModel: CollectionViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.collectionMangas) { mangaCollection in
                CollectionMangaRow(
                    mangaCollection: mangaCollection,
                    onRemove: {
                        Task {
                            await viewModel.removeFromCollection(mangaCollection)
                        }
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
    let viewModel = CollectionViewModel()
    
    viewModel.collectionMangas = [
        MangaCollection(
            manga: .preview,
            volumesPurchased: 15,
            currentVolume: 12,
            isCompleteCollection: false
        ),
        MangaCollection(
            manga: .preview,
            volumesPurchased: 42,
            currentVolume: 42,
            isCompleteCollection: true
        )
    ]
    
    return CollectionList(viewModel: viewModel)
}
