import SwiftUI

struct RemoteCollectionView: View {
    @State private var viewModel = RemoteCollectionViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty && !viewModel.isLoading {
                    CollectionEmptyState()
                } else {
                    RemoteCollectionList(viewModel: viewModel)
                }
            }
            .navigationTitle(
                "collection.navigation.title".localized()
            )
            .task {
                await viewModel.loadCollection()
            }
            .refreshable {
                await viewModel.loadCollection()
            }
        }
    }
}

#Preview {
    RemoteCollectionView()
}
