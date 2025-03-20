import SwiftUI

let articleItems: [ArticleItem] = [
    ArticleItem(
        title: "Partnership between Govt, business community more important than before: PM Wong",
        subTitle: ArticleItem.createSubtitle(from: loadTextFromFile(named: "WongSpeech") ?? ""),
        image: "ART_01",
        tags: ["Politics", "Government", "Business"],
        content: loadTextFromFile(named: "WongSpeech") ?? ""
    ),
    ArticleItem(
        title: "Free playgrounds your kids will love, from Bidadari to Tengah",
        subTitle: ArticleItem.createSubtitle(from: loadTextFromFile(named: "WongSpeech") ?? ""),
        image: "ART_02",
        tags: ["Children", "Lifestyle", "Culture"],
        content: loadTextFromFile(named: "Playgrounds") ?? ""
    ),
    ArticleItem(
        title: "Get tips to help your child at ST’s Smart Parenting PSLE Prep Forum",
        subTitle: ArticleItem.createSubtitle(from: loadTextFromFile(named: "WongSpeech") ?? ""),
        image: "ART_03",
        tags: ["School", "Children", "Parenting"],
        content: loadTextFromFile(named: "PSLE") ?? ""
    ),
]

func searchArticles(with searchText: String) -> [ArticleItem] {
    if searchText.isEmpty {
        return articleItems
    }
    
    return articleItems.filter { item in
        item.title.localizedCaseInsensitiveContains(searchText) ||
        item.subTitle.localizedCaseInsensitiveContains(searchText) ||
        item.tags.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
        (item.content.localizedCaseInsensitiveContains(searchText))
    }
}
