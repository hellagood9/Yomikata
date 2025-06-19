import SwiftUI

struct MangaDetailCategories: View {
    let manga: Manga

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !manga.demographics.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("detail.demographics".localized())
                        .font(.headline)
                        .fontWeight(.semibold)

                    FlowLayout(
                        data: manga.demographics.map { $0.demographic },
                        spacing: 8,
                        horizontalSpacing: 8
                    ) { demographic in
                        DemographicTag(demographic: demographic)
                    }
                }
            }

            if !manga.genres.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("detail.genres".localized())
                        .font(.headline)
                        .fontWeight(.semibold)

                    FlowLayout(
                        data: manga.genres,
                        spacing: 8,
                        horizontalSpacing: 8
                    ) { genre in
                        GenreTag(genre: genre)
                    }
                }
            }

            if !manga.themes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("detail.themes".localized())
                        .font(.headline)
                        .fontWeight(.semibold)

                    FlowLayout(
                        data: manga.themes,
                        spacing: 8,
                        horizontalSpacing: 8
                    ) { theme in
                        ThemeTag(theme: theme)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Authors")
                    .font(.headline)
                    .fontWeight(.semibold)

                FlowLayout(
                    data: manga.authors,
                    spacing: 8,
                    horizontalSpacing: 8
                ) { author in
                    AuthorTag(author: author, showRole: true)
                }
            }
        }
    }
}

#Preview {
    MangaDetailCategories(manga: .preview)
}
