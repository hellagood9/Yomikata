import Foundation

@MainActor
@Observable
final class MangaListViewModel {
    // MARK: - Published State
    var mangas: [Manga] = []
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    var searchText = ""
    var selectedGenre: String = ""
    var isGridView = false
    private var searchTask: Task<Void, Never>?

    var availableGenres: [String] = []

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

    /// Carga los géneros
    func loadGenres() async {
        do {
            availableGenres = try await apiService.getGenres()
        } catch {
            print("🔥 Error loading genres: \(error)")
        }
    }

    /// Busca mangas por su titulo
    func searchMangas() async {
        // Cancelar búsqueda anterior
        searchTask?.cancel()

        // Nueva tarea con debounce
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)  // 0.3 segundos

            guard !Task.isCancelled else { return }

            if searchText.isEmpty {
                await loadMangas()
            } else {
                isLoading = true
                defer { isLoading = false }

                do {
                    let response = try await apiService.searchMangasContains(
                        searchText)
                    guard !Task.isCancelled else { return }
                    mangas = response.items
                    errorMessage = nil
                } catch {
                    guard !Task.isCancelled else { return }
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// Filtra por género
    func filterByGenre(_ genre: String) async {
        selectedGenre = genre

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await apiService.getMangasByGenre(genre)
            mangas = response.items
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
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
