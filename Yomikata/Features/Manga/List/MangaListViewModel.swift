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
    var isGridView = false
    private var searchTask: Task<Void, Never>?

    // MARK: - Current Filter State (PARA TRACKING INTERNO)
    var selectedGenres: [String] = []
    var selectedThemes: [String] = []
    var selectedDemographics: [String] = []
    var selectedAuthors: [String] = []

    // MARK: - Filter State (PARA BADGE)

    /// Indica si hay algún filtro activo
    var hasActiveFilter: Bool {
        !selectedGenres.isEmpty || !selectedThemes.isEmpty
            || !selectedDemographics.isEmpty || !selectedAuthors.isEmpty
    }

    /// Cuenta total de filtros activos (múltiples)
    var activeFilterCount: Int {
        selectedGenres.count + selectedThemes.count + selectedDemographics.count
            + selectedAuthors.count
    }

    // MARK: - Search State
    private var isCurrentlySearching: Bool {
        !searchText.isEmpty
    }

    // MARK: - Filter State
    private var isCurrentlyFiltering: Bool {
        hasActiveFilter
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
                let customSearch = CustomSearch(
                    searchTitle: searchText,
                    searchGenres: selectedGenres.isEmpty ? nil : selectedGenres,
                    searchThemes: selectedThemes.isEmpty ? nil : selectedThemes,
                    searchDemographics: selectedDemographics.isEmpty
                        ? nil : selectedDemographics,
                    searchContains: true
                )

                response = try await apiService.customSearchMangas(
                    customSearch, page: nextPage)
            } else if isCurrentlyFiltering {
                // Filtros con paginación usando CustomSearch
                let customSearch = CustomSearch(
                    searchTitle: nil,
                    searchGenres: selectedGenres.isEmpty ? nil : selectedGenres,
                    searchThemes: selectedThemes.isEmpty ? nil : selectedThemes,
                    searchDemographics: selectedDemographics.isEmpty
                        ? nil : selectedDemographics,
                    searchContains: true
                )
                response = try await apiService.customSearchMangas(
                    customSearch, page: nextPage)
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

    /// Aplica filtros múltiples usando CustomSearch
    func applyCustomFilters() async {
        guard hasActiveFilter || !searchText.isEmpty else {
            await loadMangas()
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let customSearch = CustomSearch(
                searchTitle: searchText.isEmpty ? nil : searchText,
                searchGenres: selectedGenres.isEmpty ? nil : selectedGenres,
                searchThemes: selectedThemes.isEmpty ? nil : selectedThemes,
                searchDemographics: selectedDemographics.isEmpty
                    ? nil : selectedDemographics,
                searchContains: true
            )

            let response = try await apiService.customSearchMangas(customSearch)
            mangas = response.items
            errorMessage = nil

            paginationManager.reset()
            paginationManager.updateWith(response: response)

            print("✅ Custom filters applied: \(response.items.count) mangas")
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 Error applying custom filters: \(error)")
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
                if isCurrentlyFiltering {
                    // Volver a los filtros que estaban activos
                    await applyCustomFilters()
                    print("Active filters applied")
                } else {
                    // Si no hay filtros, volver al listado normal
                    await loadMangas()
                    print("Default manga list")
                }
            } else {
                isLoading = true
                defer { isLoading = false }

                do {
                    let customSearch = CustomSearch(
                        searchTitle: searchText,
                        searchGenres: selectedGenres.isEmpty
                            ? nil : selectedGenres,
                        searchThemes: selectedThemes.isEmpty
                            ? nil : selectedThemes,
                        searchDemographics: selectedDemographics.isEmpty
                            ? nil : selectedDemographics,
                        searchContains: true
                    )

                    let response = try await apiService.customSearchMangas(
                        customSearch)

                    guard !Task.isCancelled else { return }

                    mangas = response.items
                    errorMessage = nil

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

    // MARK: - Multiple Filter Methods

    /// Agrega/quita un género de los filtros
    func toggleGenre(_ genre: String) async {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll { $0 == genre }
        } else {
            selectedGenres.append(genre)
        }
        await applyCustomFilters()
    }

    /// Agrega/quita un tema de los filtros
    func toggleTheme(_ theme: String) async {
        if selectedThemes.contains(theme) {
            selectedThemes.removeAll { $0 == theme }
        } else {
            selectedThemes.append(theme)
        }
        await applyCustomFilters()
    }

    /// Agrega/quita una demografía de los filtros
    func toggleDemographic(_ demographic: String) async {
        if selectedDemographics.contains(demographic) {
            selectedDemographics.removeAll { $0 == demographic }
        } else {
            selectedDemographics.append(demographic)
        }
        await applyCustomFilters()
    }

    /// Agrega/quita un autor de los filtros
    func toggleAuthor(_ authorId: String) async {
        if selectedAuthors.contains(authorId) {
            selectedAuthors.removeAll { $0 == authorId }
        } else {
            selectedAuthors.append(authorId)
        }
        await applyCustomFilters()
    }

    /// Limpia todos los filtros
    func clearAllFilters() async {
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
        selectedAuthors.removeAll()
        await loadMangas()
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
