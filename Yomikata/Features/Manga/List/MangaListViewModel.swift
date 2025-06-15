import Foundation

@MainActor
@Observable
final class MangaListViewModel {
    // MARK: - Published State
    var mangas: [Manga] = []
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    var isGridView = false

    // MARK: - Dependencies
    private let apiService = APIService()
    private let paginationManager = PaginationManager()

    // MARK: - Public Interface

    /// Carga mangas solo si es necesario (primera vez o lista vacía)
    func loadMangasIfNeeded() async {
        guard mangas.isEmpty && !isLoading else { return }
        await loadMangas()
    }

    /// Carga la primera página de mangas
    func loadMangas() async {
        guard !isLoading else { return }

        isLoading = true
        paginationManager.reset()
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await apiService.getMangas(
                page: 1,
                per: APIConstants.defaultItemsPerPage
            )
            mangas = response.items
            paginationManager.updateWith(response: response)

            print("✅ Loaded page 1: \(response.items.count) mangas")
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 Error loading mangas: \(error)")
        }
    }

    /// Carga la siguiente página de mangas
    func loadMoreMangas() async {
        guard canLoadMore else { return }

        isLoadingMore = true
        errorMessage = nil

        defer { isLoadingMore = false }

        do {
            let nextPage = paginationManager.getNextPageForRequest()
            let response = try await apiService.getMangas(
                page: nextPage,
                per: APIConstants.defaultItemsPerPage
            )

            mangas.append(contentsOf: response.items)
            paginationManager.updateWith(response: response)

            print(
                "✅ Loaded page \(nextPage): \(response.items.count) more mangas"
            )
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 Error loading more mangas: \(error)")
        }
    }

    /// Recarga toda la lista desde el principio
    func refreshMangas() async {
        await loadMangas()
    }

    // MARK: - Computed Properties

    var canLoadMore: Bool {
        paginationManager.canLoadMore() && !isLoading && !isLoadingMore
    }

    var isAnyLoading: Bool {
        isLoading || isLoadingMore
    }

    var totalMangasLoaded: Int {
        mangas.count
    }

    var paginationInfo: String {
        paginationManager.progressInfo
    }
}
