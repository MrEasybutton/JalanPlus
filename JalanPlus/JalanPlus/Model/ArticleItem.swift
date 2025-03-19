import SwiftUI

struct ArticleItem: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
    var tags: [String]
}

var articleItems: [ArticleItem] = [
    .init(title: "Partnership between Govt...",
          subTitle: "The world is changing in ways that will have a huge impact on Singapore's economy, businesses...",
          image: "ART_01",
          tags: ["Government", "Economy", "Business"]),
    .init(title: "Local Culture",
          subTitle: "I have no idea what to write as filler but lorom dorem ipsum dolo amet ricin...",
          image: "ART_02",
          tags: ["Culture", "Local", "Lifestyle"]),
    .init(title: "Touring the Garden City",
          subTitle: "Private sector economists kept unchanged their forecast for economic growth in Singapore at 2.6 per cent...",
          image: "ART_03",
          tags: ["Tourism", "Garden City", "Travel"])
]

func searchArticles(with searchText: String) -> [ArticleItem] {
    if searchText.isEmpty {
        return articleItems
    }
    
    return articleItems.filter { item in
        item.title.localizedCaseInsensitiveContains(searchText) ||
        item.subTitle.localizedCaseInsensitiveContains(searchText) ||
        item.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
