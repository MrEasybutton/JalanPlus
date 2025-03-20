import SwiftUI

struct ArticleDetailView: View {
    var article: ArticleItem
    @Environment(\.presentationMode) var presentationMode
    @State private var scrollOffset: CGFloat = 0
    @State private var titleOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    GeometryReader { geo in
                        let offset = geo.frame(in: .global).minY
                        let height = geo.size.height
                        
                        Image(article.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: height + (offset > 0 ? offset : 0))
                            .clipped()
                            .offset(y: offset > 0 ? -offset : 0)
                            .opacity(scrollOffset < 0 ? 1.0 + (scrollOffset / 500) : 1.0)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(article.title)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.bottom, 4)
                                        .offset(y: max(offset, 0))

                                    Text(article.subTitle)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                        .offset(y: max(offset, 0))
                                }
                            )

                    }
                    .frame(height: 400)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(article.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                    
                    Text(article.content)
                        .font(.custom("Frank Ruhl Libre", size: 20))
                        .lineSpacing(6)
                        .padding()
                        .opacity(contentOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                                contentOpacity = 1
                            }
                        }
                    
                    Spacer(minLength: 60)
                }
                .background(GeometryReader { geo in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    withAnimation(.easeInOut) {
                        titleOpacity = value < -300 ? 1 : 0
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(Color(.systemBackground).opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(1)
                        .opacity(titleOpacity)
                    
                    Spacer()
                    
                    Button(action: {
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(Color(.systemBackground).opacity(0.8))
                            .clipShape(Circle())
                    }
                    // THIS HAS ZERO FUNCTIONALITY RN, PROB WILL UPDATE WITH SHARELINK
                }
                .padding(.horizontal)
                .offset(y: -20)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    Explore()
}
