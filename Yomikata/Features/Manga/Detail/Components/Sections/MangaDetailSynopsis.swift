import SwiftUI

struct MangaDetailSynopsis: View {
    let manga: Manga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("detail.synopsis".localized())
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(
                manga.cleanSynopsis
                ?? "detail.no_synopsis_available".localized()
            )
            .font(.body)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    MangaDetailSynopsis(manga: .preview)
}
