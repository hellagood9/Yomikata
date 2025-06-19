import SwiftUI

struct MangaMainPicture: View {
    let url: URL?
    let assetName: String?
    let iconSize: CGFloat

    init(url: URL?, assetName: String?, iconSize: CGFloat = 16) {
        self.url = url
        self.assetName = assetName
        self.iconSize = iconSize
    }

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
                    placeholder
                }
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            Color(.systemGray5)

            Image(systemName: "photo")
                .font(.system(size: iconSize))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MangaMainPicture(
            url: URL(
                string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"
            ),
            assetName: "267793l"
        )
        .frame(width: 200, height: 240)

        Text("List")
        MangaMainPicture(url: nil, assetName: nil)
            .frame(width: 60, height: 90)

        Text("Grid")
        MangaMainPicture(url: nil, assetName: nil, iconSize: 30)
            .frame(width: 120, height: 180)
    }
}
