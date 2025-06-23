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

    // MARK: - Filter State (PARA BADGE)

    /// Indica si hay algún filtro activo
    var hasActiveFilter: Bool {
        !selectedGenre.isEmpty || !selectedTheme.isEmpty
            || !selectedDemographic.isEmpty || !selectedAuthor.isEmpty
    }

    /// Cuenta total de filtros activos (siempre será 1 en versión básica y media , múltiples en versión avanzada)
    var activeFilterCount: Int {
        var count = 0
        if !selectedGenre.isEmpty { count += 1 }
        if !selectedTheme.isEmpty { count += 1 }
        if !selectedDemographic.isEmpty { count += 1 }
        if !selectedAuthor.isEmpty { count += 1 }
        return count
    }

    // MARK: - Current Filter State (PARA TRACKING INTERNO)
    var selectedTheme: String = ""
    var selectedDemographic: String = ""
    var selectedAuthor: String = ""

    // MARK: - Search State
    private var isCurrentlySearching: Bool {
        !searchText.isEmpty
    }

    // MARK: - Filter State
    private var isCurrentlyFiltering: Bool {
        hasActiveFilter
    }
    private var currentFilterType: FilterType? {
        if !selectedGenre.isEmpty { return .genre }
        if !selectedTheme.isEmpty { return .theme }
        if !selectedDemographic.isEmpty { return .demographic }
        if !selectedAuthor.isEmpty { return .author }
        return nil
    }

    private var currentFilterValue: String {
        if !selectedGenre.isEmpty { return selectedGenre }
        if !selectedTheme.isEmpty { return selectedTheme }
        if !selectedDemographic.isEmpty { return selectedDemographic }
        if !selectedAuthor.isEmpty { return selectedAuthor }
        return ""
    }

    var availableGenres: [String] = []
    var availableThemes: [String] = []
    var availableDemographics: [String] = []
    var availableAuthors: [Author] = []

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
        guard canLoadMore
        else {
            print(
                "🚫 Blocked loadMoreMangas - isSearching: \(isCurrentlySearching), isFiltering: \(isCurrentlyFiltering)"
            )
            return
        }

        isLoadingMore = true
        errorMessage = nil

        defer { isLoadingMore = false }

        do {
            let nextPage = paginationManager.getNextPageForRequest()
            let response: PaginatedResponse<[Manga]>

            if isCurrentlySearching {
                // Búsqueda con paginación
                response = try await apiService.searchMangasContains(
                    searchText, page: nextPage)
            } else if isCurrentlyFiltering, let filterType = currentFilterType {
                // Filtros con paginación
                switch filterType {
                case .genre:
                    response = try await apiService.getMangasByGenre(
                        currentFilterValue, page: nextPage)
                case .theme:
                    response = try await apiService.getMangasByTheme(
                        currentFilterValue, page: nextPage)
                case .demographic:
                    response = try await apiService.getMangasByDemographic(
                        currentFilterValue, page: nextPage)
                case .author:
                    response = try await apiService.getMangasByAuthor(
                        currentFilterValue, page: nextPage)
                }
            } else {
                response = try await apiService.getMangas(
                    page: nextPage, per: APIConstants.defaultItemsPerPage)
            }

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
        // ✅ FIX: Si estamos buscando, repetir la búsqueda
        if isCurrentlySearching {
            await searchMangas()
        } else {
            await loadMangas()
        }
    }

    // MARK: - Filter Data Loading

    /// Carga los géneros
    func loadGenres() async {
        do {
            availableGenres = try await apiService.getGenres()
        } catch {
            print("🔥 Error loading genres: \(error)")
        }
    }

    /// Carga las temáticas
    func loadThemes() async {
        do {
            availableThemes = try await apiService.getThemes()
        } catch {
            print("🔥 Error loading themes: \(error)")
        }
    }

    /// Carga las demográficas
    func loadDemographics() async {
        do {
            availableDemographics = try await apiService.getDemographics()
        } catch {
            print("🔥 Error loading demographics: \(error)")
        }
    }

    /// Carga los autores
    func loadAuthors() async {
        do {
            availableAuthors = try await apiService.getAuthors()
        } catch {
            print("🔥 Error loading authors: \(error)")
        }
    }

    // MARK: - Search and Filtering

    /// Busca mangas por su titulo
    func searchMangas() async {
        // Cancelar búsqueda anterior
        searchTask?.cancel()

        // Nueva tarea con debounce
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000)  // 0.3 segundos

            guard !Task.isCancelled else { return }

            if searchText.isEmpty {
                // FIX: Si no hay búsqueda, verificar si hay filtros activos
                if isCurrentlyFiltering, let filterType = currentFilterType {
                    // Volver al filtro que estaba activo
                    await applySingleFilter(
                        type: filterType, value: currentFilterValue)
                    print("Active filter: \(currentFilterValue)")
                } else {
                    // Si no hay filtros, volver al listado normal
                    await loadMangas()
                    print("Default manga list")
                }
            } else {
                isLoading = true
                defer { isLoading = false }

                do {
                    let response = try await apiService.searchMangasContains(
                        searchText)
                    guard !Task.isCancelled else { return }

                    mangas = response.items
                    errorMessage = nil

                    if mangas.count > 8 {
                        print("⚠️ PROBLEMA: mangas array tiene más de 8 items!")
                        print(
                            "🔍 Items 9+: \(mangas.dropFirst(8).map { $0.title })"
                        )
                    }

                    paginationManager.reset()
                    paginationManager.updateWith(response: response)

                    print(
                        "✅ Search results: \(response.items.count) mangas for '\(searchText)'"
                    )
                } catch {
                    guard !Task.isCancelled else { return }
                    errorMessage = error.localizedDescription
                    print("🔥 Error searching: \(error)")
                }
            }
        }
    }

    // IMPORTANT: Limpiar otros filtros (Versión básica/media: solo uno activo)

    /// Filtra por género
    func filterByGenre(_ genre: String) async {
        selectedTheme = ""
        selectedDemographic = ""
        selectedAuthor = ""
        selectedGenre = genre

        await applySingleFilter(type: .genre, value: genre)
    }

    /// Filtra por tema
    func filterByTheme(_ theme: String) async {
        selectedGenre = ""
        selectedDemographic = ""
        selectedAuthor = ""
        selectedTheme = theme

        await applySingleFilter(type: .theme, value: theme)
    }

    /// Filtra por demográfica
    func filterByDemographic(_ demographic: String) async {
        selectedGenre = ""
        selectedTheme = ""
        selectedAuthor = ""
        selectedDemographic = demographic

        await applySingleFilter(type: .demographic, value: demographic)
    }

    /// Filtra por autor
    func filterByAuthor(_ authorId: String) async {
        selectedGenre = ""
        selectedTheme = ""
        selectedDemographic = ""
        selectedAuthor = authorId

        await applySingleFilter(type: .author, value: authorId)
    }

    /// Limpia todos los filtros
    func clearAllFilters() async {
        selectedGenre = ""
        selectedTheme = ""
        selectedDemographic = ""
        selectedAuthor = ""
        await loadMangas()
    }

    // MARK: - Private Methods

    private enum FilterType {
        case genre, theme, demographic, author
    }

    /// Aplica un filtro específico
    private func applySingleFilter(type: FilterType, value: String) async {
        guard !value.isEmpty else {
            await loadMangas()
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response: PaginatedResponse<[Manga]>

            switch type {
            case .genre:
                response = try await apiService.getMangasByGenre(value)
            case .theme:
                response = try await apiService.getMangasByTheme(value)
            case .demographic:
                response = try await apiService.getMangasByDemographic(value)
            case .author:
                response = try await apiService.getMangasByAuthor(value)
            }

            mangas = response.items
            errorMessage = nil

            paginationManager.reset()
            paginationManager.updateWith(response: response)

            print("✅ Filter applied: \(response.items.count) mangas")
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 Error applying filter: \(error)")
        }
    }

    // MARK: - Computed Properties

    var canLoadMore: Bool {
        // FIX: Solo permitir load more si no estamos buscando
        paginationManager.canLoadMore() && !isLoading && !isLoadingMore
    }

    var isAnyLoading: Bool {
        isLoading || isLoadingMore
    }

    var totalMangasLoaded: Int {
        mangas.count
    }

    var paginationInfo: String {
        if isCurrentlySearching {
            return "Search results: \(mangas.count)"
        }
        return paginationManager.progressInfo
    }
}
