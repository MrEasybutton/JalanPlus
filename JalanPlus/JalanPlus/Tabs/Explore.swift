import SwiftUI
import UIKit
import Liquor

struct Explore: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Today(searchText: $searchText)
                    Articles(searchText: $searchText)
                }
            }
            // .navigationBarTitle("Explore", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct Today: View {
    @Binding var searchText: String
    let darkRed = Color(red: 0.55, green: 0.12, blue: 0.12)
    @Environment(\.colorScheme) var colorScheme
    @State private var searchPlaceholder = "Search blogs or tags..."

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NeumorphicSearchBar(text: $searchText, placeholder: "Search tags or blogs", cornerRadius: 12)
                .padding()
                .offset(y: 12)

            if !searchText.isEmpty {
                let (_, filteredTodayItems) = searchAllItems(with: searchText)

                if !filteredTodayItems.isEmpty {
                    Rail(
                        items: filteredTodayItems,
                        title: "Today's blogs concerning: \"\(searchText)\"",
                        titleColor: colorScheme == .dark ? .white : .black,
                        titleKeyPath: \.title,
                        subTitleKeyPath: \.subTitle,
                        imageKeyPath: \.image,
                        tagsKeyPath: \.tags
                    )
                    .frame(height: 400)
                }
            } else {
                Rail(
                    items: todayItems,
                    title: "Discover",
                    titleColor: colorScheme == .dark ? .white : .black,
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .frame(height: 400)
            }
        }
    }
}


struct Articles: View {
    @Binding var searchText: String
    let darkRed = Color(red: 0.55, green: 0.12, blue: 0.12)
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !searchText.isEmpty {
                let (filteredArticles, _) = searchAllItems(with: searchText)

                if !filteredArticles.isEmpty {
                    Rail(
                        items: filteredArticles,
                        title: "Articles that talked about \"\(searchText)\"",
                        titleColor: colorScheme == .dark ? .white : .black,
                        titleKeyPath: \.title,
                        subTitleKeyPath: \.subTitle,
                        imageKeyPath: \.image,
                        tagsKeyPath: \.tags
                    )
                    .frame(height: 600)
                }
            } else {
                Rail(
                    items: articleItems,
                    title: "Articles",
                    titleColor: .white,
                    titleKeyPath: \.title,
                    subTitleKeyPath: \.subTitle,
                    imageKeyPath: \.image,
                    tagsKeyPath: \.tags
                )
                .frame(height: 600)
                .background(darkRed)
                .overlay(
                    Rectangle()
                        .stroke(darkRed, lineWidth: 8)
                        .blur(radius: 1.2)
                )
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
    var contentKeyPath: KeyPath<T, String>? = nil
    
    @State private var activeNavigation: T? = nil
    @State private var isNavigating = false
    
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
                imageForItem: { item in
                    item[keyPath: imageKeyPath]
                },
                titleForItem: { item in
                    let title = item[keyPath: titleKeyPath]
                    return title.count > 20 ? String(title.prefix(40)) + "…" : title
                },
                subTitleForItem: { item in
                    let subtitle = item[keyPath: subTitleKeyPath]
                    return subtitle.count > 30 ? String(subtitle.prefix(40)) + "…" : subtitle
                },
                tagsForItem: tagsKeyPath != nil ? { item in
                    item[keyPath: tagsKeyPath!]
                } : nil,
                onItemSelected: { item in
                    self.activeNavigation = item
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isNavigating = true
                    }
                }
            )
            .background(
                Group {
                    if let selectedItem = activeNavigation,
                       let articleItem = selectedItem as? ArticleItem {
                        NavigationLink(
                            destination: ArticleDetailView(article: articleItem)
                                .transition(.opacity),
                            isActive: $isNavigating
                        ) {
                            EmptyView()
                        }
                    }
                }
            )
            Spacer()
        }
        .offset(y: -20)
        .ignoresSafeArea()
    }
}

func searchAllItems(with searchText: String) -> ([ArticleItem], [ArticleItem]) {
    let filteredArticles = searchArticles(with: searchText)
    let filteredTodayItems = searchToday(with: searchText)
    return (filteredArticles, filteredTodayItems)
}

#Preview {
    Explore()
}
