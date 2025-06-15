import SwiftUI

struct MangaDetailCategories: View {
    let manga: Manga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !manga.genres.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("detail.genres".localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 80))
                        ], spacing: 8
                    ) {
                        ForEach(manga.genres, id: \.self) { genre in
                            GenreTag(genre: genre)
                        }
                    }
                }
            }
            
            if !manga.themes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("detail.themes".localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 80))
                        ], spacing: 8
                    ) {
                        ForEach(manga.themes, id: \.self) { theme in
                            ThemeTag(theme: theme)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MangaDetailCategories(manga: .preview)
}
