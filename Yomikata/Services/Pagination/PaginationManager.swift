import Foundation

final class PaginationManager {

    // MARK: - State
    private(set) var currentPage: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var totalItems: Int = 0
    private(set) var itemsPerPage: Int
    private(set) var hasMorePages: Bool = true

    // MARK: - Initialization
    init(itemsPerPage: Int = APIConstants.defaultItemsPerPage) {
        self.itemsPerPage = itemsPerPage
    }

    // MARK: - Public Interface

    /// Reinicia la paginación al estado inicial
    func reset() {
        currentPage = 1
        totalPages = 1
        totalItems = 0
        hasMorePages = true
    }

    /// Actualiza el estado con la respuesta paginada
    func updateWith<T: Codable>(response: PaginatedResponse<T>) {
        let metadata = response.metadata

        totalItems = metadata.total
        currentPage = metadata.page
        itemsPerPage = metadata.per

        // Calcular páginas totales
        totalPages = (totalItems + itemsPerPage - 1) / itemsPerPage
        hasMorePages = currentPage < totalPages

        print(
            "📄 Page \(currentPage)/\(totalPages) | Total: \(totalItems) | Per page: \(itemsPerPage) | Has more: \(hasMorePages)"
        )
    }

    /// Verifica si se puede cargar más contenido
    func canLoadMore() -> Bool {
        return hasMorePages
    }

    /// Obtiene la siguiente página para la request
    func getNextPageForRequest() -> Int {
        return currentPage + 1
    }

    // MARK: - Computed Properties

    var progressInfo: String {
        "Page \(currentPage) of \(totalPages) (\(totalItems) total items)"
    }

    var isFirstPage: Bool {
        currentPage == 1
    }

    var isLastPage: Bool {
        currentPage == totalPages
    }
}
