import SwiftUI

let todayItems: [ArticleItem] = [
    ArticleItem(
        title: "Casual Poet Library",
        subTitle: "Hello! We are a shared community library in the heartlands of Singapore—Alexandra Village, to be specific, a cosy little neighbourhood...",
        image: "CPL_01",
        tags: ["Library", "Community", "Books"],
        content: """
        # Getting Started with SwiftUI
        
        SwiftUI is a revolutionary framework that makes building user interfaces across all Apple platforms easier than ever before. This article covers the basics of SwiftUI and how to get started with your first project.
""" ),
    ArticleItem(title: "Kill yourself Tai Kiat",
          subTitle: "Our shared library is entirely community-funded. Every shelf in our library is rented and curated by...",
          image: "CPL_02",
          tags: ["Community", "Funding", "Curation"],
          content: """
          # Getting Started with SwiftUI
          
          SwiftUI is a revolutionary framework that makes building user interfaces across all Apple platforms easier than ever before. This article covers the basics of SwiftUI and how to get started with your first project.
  """ ),
    ArticleItem(title: "Kanye West",
          subTitle: "We see the huge potential our world has for healing, growth and connection. But to create a new world we need new ways of...",
          image: "CPL_03",
          tags: ["Music", "Art", "Culture"],
          content: """
          # Getting Started with SwiftUI
          
          SwiftUI is a revolutionary framework that makes building user interfaces across all Apple platforms easier than ever before. This article covers the basics of SwiftUI and how to get started with your first project.
  """ ),
]

func searchToday(with searchText: String) -> [ArticleItem] {
    if searchText.isEmpty {
        return todayItems
    }
    
    return todayItems.filter { item in
        item.title.localizedCaseInsensitiveContains(searchText) ||
        item.subTitle.localizedCaseInsensitiveContains(searchText) ||
        item.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
