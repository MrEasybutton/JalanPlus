import SwiftUI
import Liquor

struct Explore: View {
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Today(searchText: $searchText)
            }
        }
    }
}

struct Today: View {
    @Binding var searchText: String
    @State private var searchPlaceholder = "Search blogs or tags..."
    let darkRed = Color(red: 0.55, green: 0.12, blue: 0.12)
    

    var filteredArticles: [ArticleItem] {
        return searchArticles(with: searchText)
        // return searchToday(with: searchText)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NeumorphicSrcBar(text: $searchText, placeholder: searchPlaceholder, cornerRadius: 16)
                .offset(y: 20)
            
            if !searchText.isEmpty {
                Text("Search results for: \"\(searchText)\"")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 30)

                Rail(
                    items: filteredArticles,
                    title: "Results",
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .frame(height: 400)
            } else {
                Rail(
                    items: todayItems,
                    title: "Discover",
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .frame(height: 400)

                Rail(
                    items: articleItems,
                    title: "Articles",
                    titleColor: .white,
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .background(darkRed)
                .overlay(
                    Rectangle()
                        .stroke(darkRed, lineWidth: 8)
                        .blur(radius: 1.2)
                )
                .frame(height: 600)
                
                Rail(
                    items: articleItems,
                    title: "Events",
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .background(.white)
                .overlay(
                    Rectangle()
                        .stroke(.white, lineWidth: 8)
                        .blur(radius: 1.2)
                )
                .frame(height: 450)
            }
        }
    }
}

struct Rail<T: Identifiable & Hashable>: View {
    var items: [T]
    var title: String
    var titleColor: Color = .black
    var titleKeyPath: KeyPath<T, String>
    var subTitleKeyPath: KeyPath<T, String>
    var imageKeyPath: KeyPath<T, String>
    var tagsKeyPath: KeyPath<T, [String]>? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit", size: 42))
                .foregroundStyle(titleColor)
                .padding(.leading)
                .shadow(radius: 18)
                .padding(.bottom, 10)
                .padding(.top, 20)
                .offset(y: 20)
            CarouselView(
                items: items,
                imageForItem: { $0[keyPath: imageKeyPath] },
                titleForItem: { $0[keyPath: titleKeyPath] },
                subTitleForItem: { $0[keyPath: subTitleKeyPath] },
                tagsForItem: tagsKeyPath != nil ? { $0[keyPath: tagsKeyPath!] } : nil
            )
            Spacer()
        }
        .offset(y: -20)
        .ignoresSafeArea()
    }
}

#Preview {
    Explore()
}
