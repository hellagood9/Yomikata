import SwiftUI

struct CollectionStats {
    let totalMangas: Int
    let completedCollections: Int
    let totalVolumesOwned: Int

    var completionRate: Double {
        guard totalMangas > 0 else { return 0.0 }
        return Double(completedCollections) / Double(totalMangas)
    }
}

struct CollectionStatsSection: View {
    let stats: CollectionStats

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        Section {
            LazyVGrid(columns: columns, spacing: 12) {
                InfoCard(
                    title: "collection.stats.total".localized(
                        fallback: "Mangas Totales"),
                    value: "\(stats.totalMangas)",
                    icon: "books.vertical.fill"
                )

                InfoCard(
                    title: "collection.stats.completed".localized(
                        fallback: "Completados"),
                    value: "\(stats.completedCollections)",
                    icon: "checkmark.circle.fill"
                )

                InfoCard(
                    title: "collection.stats.volumes".localized(
                        fallback: "Tomos Comprados"),
                    value: "\(stats.totalVolumesOwned)",
                    icon: "book.closed.fill"
                )

                InfoCard(
                    title: "collection.stats.rate".localized(
                        fallback: "Porcentaje de Finalización"),
                    value: "\(Int(stats.completionRate * 100))%",
                    icon: "percent"
                )
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    CollectionStatsSection(
        stats: CollectionStats(
            totalMangas: 2,
            completedCollections: 1,
            totalVolumesOwned: 5
        )
    )

}
