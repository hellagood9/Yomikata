import SwiftUI

struct CollectionView: View {
    @State private var viewModel = CollectionViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty && !viewModel.isLoading {
                    CollectionEmptyState()
                } else {
                    CollectionList(viewModel: viewModel)
                }
            }
            .navigationTitle("collection.navigation.title".localized(fallback: "Collection"))
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
    CollectionView()
}
