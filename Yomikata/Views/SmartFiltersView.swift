import SwiftUI

struct SmartFiltersView: View {
    @Binding var isPresented: Bool
    @Bindable var viewModel: MangaListViewModel

    @State private var selectedGenres: Set<String> = []
    @State private var selectedThemes: Set<String> = []
    @State private var selectedDemographics: Set<String> = []
    @State private var selectedAuthors: Set<Author> = []

    // Cambiar esto a true para filtros múltiples
    private let supportsMultipleFilters: Bool = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Géneros
                    SmartFilterSection(
                        title: "filter.genres".localized(),
                        items: viewModel.availableGenres,
                        selectedItems: $selectedGenres,
                        displayTransform: { $0.localizedGenre },
                        onSelectionChange: { genre in
                            handleMultipleSelection(
                                item: genre, targetSet: $selectedGenres)
                        }
                    )

                    // Temáticas
                    SmartFilterSection(
                        title: "filter.themes".localized(),
                        items: viewModel.availableThemes,
                        selectedItems: $selectedThemes,
                        displayTransform: { $0.localizedTheme },
                        onSelectionChange: { theme in
                            handleMultipleSelection(
                                item: theme, targetSet: $selectedThemes)
                        }
                    )

                    // Demográficas
                    SmartFilterSection(
                        title: "filter.demographics".localized(),
                        items: viewModel.availableDemographics,
                        selectedItems: $selectedDemographics,
                        displayTransform: { $0.localizedDemographic },
                        onSelectionChange: { demographic in
                            handleMultipleSelection(
                                item: demographic,
                                targetSet: $selectedDemographics)
                        }
                    )

                    // Autores (limitamos a los primeros 20 para performance)
                    if !viewModel.availableAuthors.isEmpty {
                        SmartFilterSection(
                            title: "filter.authors".localized(),
                            items: Array(viewModel.availableAuthors.prefix(20)),
                            selectedItems: $selectedAuthors,
                            displayTransform: { $0.fullName },
                            onSelectionChange: { author in
                                handleMultipleSelection(
                                    item: author, targetSet: $selectedAuthors)
                            }
                        )
                    }

                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("filter.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("filter.reset".localized(fallback: "Reset")) {
                        resetAllFilters()
                    }
                    .foregroundColor(.accentColor)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .frame(width: 32, height: 32)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .overlay(alignment: .bottom) {
                // Botón Save
                VStack {
                    Button {
                        applyFilters()
                        isPresented = false
                    } label: {
                        Text("filter.apply".localized())
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(.regularMaterial)
                }
            }
        }
        .background(Color(.systemBackground))  // Fuerza el fondo del sistema
        .onAppear {
            loadCurrentFilters()
            loadAllFilterData()
        }
    }

    private func handleMultipleSelection<T: Hashable>(
        item: T, targetSet: Binding<Set<T>>
    ) {
        // Toggle en el set actual (permitir múltiples)
        if targetSet.wrappedValue.contains(item) {
            targetSet.wrappedValue.remove(item)
        } else {
            targetSet.wrappedValue.insert(item)
        }
    }

    private var totalSelectedFilters: Int {
        selectedGenres.count + selectedThemes.count + selectedDemographics.count
            + selectedAuthors.count
    }

    private func loadCurrentFilters() {
        // Cargar filtros múltiples del ViewModel
        selectedGenres = Set(viewModel.selectedGenres)
        selectedThemes = Set(viewModel.selectedThemes)
        selectedDemographics = Set(viewModel.selectedDemographics)

        // Convertir IDs de autores a objetos Author
        selectedAuthors = Set(
            viewModel.selectedAuthors.compactMap { authorId in
                viewModel.availableAuthors.first { $0.id == authorId }
            })
    }

    private func loadAllFilterData() {
        Task {
            await viewModel.loadGenres()
            await viewModel.loadThemes()
            await viewModel.loadDemographics()
            await viewModel.loadAuthors()
        }
    }

    private func applyFilters() {
        Task {
            // Aplicar todos los filtros seleccionados
            viewModel.selectedGenres = Array(selectedGenres)
            viewModel.selectedThemes = Array(selectedThemes)
            viewModel.selectedDemographics = Array(selectedDemographics)
            viewModel.selectedAuthors = selectedAuthors.map { $0.id }

            await viewModel.applyCustomFilters()
        }
    }

    private func resetAllFilters() {
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
        selectedAuthors.removeAll()

        Task {
            await viewModel.clearAllFilters()
        }
    }
}

// MARK: - Smart Filter Section
struct SmartFilterSection<T: Hashable>: View {
    let title: String
    let items: [T]
    @Binding var selectedItems: Set<T>
    let displayTransform: (T) -> String
    let onSelectionChange: (T) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                if !selectedItems.isEmpty {
                    Button("filter.clear".localized()) {
                        selectedItems.removeAll()
                    }
                    .font(.caption)
                    .foregroundColor(.accentColor)
                }
            }

            if items.isEmpty {
                Text("filter.loading".localized())
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                FlowLayout(
                    data: items,
                    spacing: 8,
                    horizontalSpacing: 8
                ) { item in
                    FilterChip(
                        text: displayTransform(item),
                        isSelected: selectedItems.contains(item)
                    ) {
                        onSelectionChange(item)
                    }
                }
            }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isSelected
                                ? Color.accentColor : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected
                                ? Color.accentColor : Color(.systemGray5),
                            lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Info Banner
struct InfoBanner: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)

            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    SmartFiltersView(
        isPresented: .constant(true),
        viewModel: MangaListViewModel()
    )
}
