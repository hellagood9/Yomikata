import SwiftUI

struct SmartFiltersView: View {
    @Binding var isPresented: Bool
    @Bindable var viewModel: MangaListViewModel

    @State private var selectedGenres: Set<String> = []
    @State private var selectedThemes: Set<String> = []
    @State private var selectedDemographics: Set<String> = []
    @State private var selectedAuthors: Set<Author> = []

    // Cambiar esto a true cuando se implemente la DB local
    private let supportsMultipleFilters: Bool = false

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
                            handleSingleSelection(
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
                            handleSingleSelection(
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
                            handleSingleSelection(
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
                                handleSingleSelection(
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

    private func handleSingleSelection<T: Hashable>(
        item: T, targetSet: Binding<Set<T>>
    ) {
        // Limpiar TODOS los otros sets primero
        clearAllOtherSelections(except: targetSet)

        // Toggle en el set actual
        if targetSet.wrappedValue.contains(item) {
            targetSet.wrappedValue.remove(item)
        } else {
            targetSet.wrappedValue = [item]  // Solo este item
        }
    }

    private func clearAllOtherSelections<T>(except keepSet: Binding<Set<T>>) {
        // Limpiar todos excepto el que se está modificando
        if !(keepSet.wrappedValue is Set<String>)
            || keepSet.wrappedValue as? Set<String> != selectedGenres
        {
            selectedGenres.removeAll()
        }
        if !(keepSet.wrappedValue is Set<String>)
            || keepSet.wrappedValue as? Set<String> != selectedThemes
        {
            selectedThemes.removeAll()
        }
        if !(keepSet.wrappedValue is Set<String>)
            || keepSet.wrappedValue as? Set<String> != selectedDemographics
        {
            selectedDemographics.removeAll()
        }
        if !(keepSet.wrappedValue is Set<Author>)
            || keepSet.wrappedValue as? Set<Author> != selectedAuthors
        {
            selectedAuthors.removeAll()
        }
    }

    private var totalSelectedFilters: Int {
        selectedGenres.count + selectedThemes.count + selectedDemographics.count
            + selectedAuthors.count
    }

    private func loadCurrentFilters() {
        // Cargar todos los tipos de filtros activos del ViewModel
        if !viewModel.selectedGenre.isEmpty {
            selectedGenres = [viewModel.selectedGenre]
        } else if !viewModel.selectedTheme.isEmpty {
            selectedThemes = [viewModel.selectedTheme]
        } else if !viewModel.selectedDemographic.isEmpty {
            selectedDemographics = [viewModel.selectedDemographic]
        } else if !viewModel.selectedAuthor.isEmpty {
            // Buscar el autor por ID en la lista disponible
            if let author = viewModel.availableAuthors.first(where: {
                $0.id == viewModel.selectedAuthor
            }) {
                selectedAuthors = [author]
            }
        }
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
            // Aplicar solo el primer filtro encontrado
            if let firstGenre = selectedGenres.first {
                await viewModel.filterByGenre(firstGenre)
            } else if let firstTheme = selectedThemes.first {
                await viewModel.filterByTheme(firstTheme)
            } else if let firstDemographic = selectedDemographics.first {
                await viewModel.filterByDemographic(firstDemographic)
            } else if let firstAuthor = selectedAuthors.first {
                await viewModel.filterByAuthor(firstAuthor.id)
            } else {
                await viewModel.clearAllFilters()
            }
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
                        .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
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
