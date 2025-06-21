import SwiftUI

// MARK: - Componente Grid Genérico
struct GenericGrid<Item: Identifiable, CardContent: View>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    let cardContent: (Item) -> CardContent
    let onLoadMore: (() async -> Void)?
    
    init(
        items: [Item],
        columns: Int = 2,
        spacing: CGFloat = 16,
        onLoadMore: (() async -> Void)? = nil,
        @ViewBuilder cardContent: @escaping (Item) -> CardContent
    ) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.onLoadMore = onLoadMore
        self.cardContent = cardContent
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()), count: columns),
                spacing: spacing
            ) {
                ForEach(items) { item in
                    cardContent(item)
                        .onAppear {
                            // Solo ejecutar onLoadMore si está disponible
                            if let onLoadMore = onLoadMore,
                               item.id == items.last?.id
                            {
                                Task {
                                    await onLoadMore()
                                }
                            }
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    GenericGrid(items: [1, 2, 3, 4, 5, 6].map { SimpleItem(id: $0, name: "Item \($0)") }) { item in
        Text(item.name)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }
}

struct SimpleItem: Identifiable {
    let id: Int
    let name: String
}
