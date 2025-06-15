import SwiftUI

struct MangaDetailInfo: View {
    let manga: Manga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("detail.information".localized())
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 12
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
                    title: "detail.score".localized(),
                    value: manga.displayScore,
                    icon: "star"
                )
            }
        }
    }
}

#Preview {
    MangaDetailInfo(manga: .preview)
}
