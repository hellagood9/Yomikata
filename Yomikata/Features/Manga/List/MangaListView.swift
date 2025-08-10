import SwiftUI

struct MangaListView: View {
    @State private var viewModel = MangaListViewModel()
    @State private var showFilters = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isGridView {
                    gridView
                } else {
                    listView
                }
            }
            .navigationTitle(
                "mangas.navigation.title".localized(fallback: "Mangas")
            )
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) {
                Task {
                    await viewModel.searchMangas()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        // Filtros Button
                        Button(action: {
                            showFilters = true
                        }) {
                            ZStack {
                                Image(systemName: "slider.vertical.3")
                                    .font(.title3)

                                // Notification Badge para filtros activos
                                if viewModel.hasActiveFilter {
                                    Text("\(viewModel.activeFilterCount)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }

                        // Grid/List Toggle
                        Button(action: {
                            viewModel.isGridView.toggle()
                        }) {
                            Image(
                                systemName: viewModel.isGridView
                                    ? "list.bullet" : "square.grid.2x2"
                            )
                            .font(.title3)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.mangas)
            .refreshable {
                await viewModel.refreshMangas()
            }
            .task {
                await viewModel.loadMangasIfNeeded()
            }
            .sheet(isPresented: $showFilters) {
                SmartFiltersView(
                    isPresented: $showFilters, viewModel: viewModel)
            }
            .overlay(alignment: .topTrailing) {
                if !viewModel.searchText.isEmpty
                    && UIDevice.current.userInterfaceIdiom != .pad
                {
                    HStack(spacing: 12) {
                        // Filtros Button flotante
                        Button(action: {
                            showFilters = true
                        }) {
                            ZStack {
                                Image(systemName: "slider.vertical.3")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 40, height: 40)
                                    .background(Color.accentColor.opacity(0.1))
                                    .clipShape(Circle())

                                // Badge para filtros activos
                                if viewModel.hasActiveFilter {
                                    Text("\(viewModel.activeFilterCount)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .overlay {
                // Loading state inicial
                if viewModel.isLoading && viewModel.mangas.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text(
                            !viewModel.hasActiveFilter
                                ? "loading.mangas".localized()
                                : "loading.filtering".localized()
                        )
                        .font(.headline)
                        .foregroundColor(.secondary)
                    }
                }
            }
            .overlay {
                // Error state
                if let errorMessage = viewModel.errorMessage,
                    viewModel.mangas.isEmpty
                {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)

                        Text("loading.error_title".localized())
                            .font(.headline)

                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("loading.retry".localized()) {
                            Task {
                                await viewModel.loadMangas()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .overlay(alignment: .bottom) {
                if viewModel.isLoadingMore {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("loading.more".localized())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        .regularMaterial, in: RoundedRectangle(cornerRadius: 20)
                    )
                    .padding(.bottom, 20)
                }
            }
            .overlay {
                // Sin resultados de búsqueda
                if !viewModel.searchText.isEmpty && viewModel.mangas.isEmpty
                    && !viewModel.isLoading
                {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text(
                            "search.no_results.mangas".localized(
                                fallback: "No mangas found")
                        )
                        .font(.headline)

                        Text(
                            "search.try_different".localized(
                                fallback: "Try a different search term")
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - List View
extension MangaListView {
    private var listView: some View {
        List {
            ForEach(viewModel.mangas) { manga in
                MangaRow(manga: manga)
                    .onAppear {
                        // Cargar más cuando aparezca el último item
                        if manga.id == viewModel.mangas.last?.id {
                            Task {
                                await viewModel.loadMoreMangas()
                            }
                        }
                    }
            }
        }
        .listStyle(.plain)
    }

    private var gridView: some View {
        MangaGrid(
            mangas: viewModel.mangas,
            columns: 2,
            onLoadMore: {
                await viewModel.loadMoreMangas()
            }
        )
    }

}

#Preview {
    List {
        ForEach(Manga.previews) { manga in
            MangaRow(manga: manga)
        }
    }
}
