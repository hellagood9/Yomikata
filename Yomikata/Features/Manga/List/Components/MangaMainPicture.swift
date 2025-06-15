import SwiftUI

struct MangaMainPicture: View {
    let url: URL?
    let assetName: String?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            default:
                if let assetName, UIImage(named: assetName) != nil {
                    Image(assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
        }

    }
}

#Preview {
    MangaMainPicture(
        url: URL(
            string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"),
        assetName: "267793l"
    )
}
