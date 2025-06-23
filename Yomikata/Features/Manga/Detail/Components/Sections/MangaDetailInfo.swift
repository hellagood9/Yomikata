import SwiftUI

struct MangaDetailInfo: View {
    let manga: Manga

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("detail.information".localized())
                .font(.headline)
                .fontWeight(.semibold)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 10
            ) {
                InfoCard(
                    title: "detail.chapters".localized(),
                    value: manga.chapters?.description
                        ?? "detail.unknown".localized(),
                    icon: "book"
                )

                InfoCard(
                    title: "detail.volumes".localized(),
                    value: manga.volumes?.description
                        ?? "detail.unknown".localized(),
                    icon: "books.vertical"
                )

                InfoCard(
                    title: "detail.status".localized(),
                    value: manga.statusDisplay,
                    icon: "clock"
                )

                InfoCard(
                    title: "detail.publication_period".localized(),
                    value: DateUtils.formatPublicationDates(
                        startDate: DateUtils.parseDate(
                            from: manga.startDate ?? "")!,
                        endDateString: manga.endDate,
                        onlyYear: true
                    ),
                    icon: "calendar"
                )
            }
        }
    }
}

#Preview {
    MangaDetailInfo(manga: .preview)
}
