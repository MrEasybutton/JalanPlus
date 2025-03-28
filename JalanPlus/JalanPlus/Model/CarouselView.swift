import SwiftUI

public struct CarouselView<ItemType>: View where ItemType: Identifiable {
    var items: [ItemType]
    var imageForItem: (ItemType) -> String
    var titleForItem: (ItemType) -> String
    var subTitleForItem: (ItemType) -> String
    var tagsForItem: ((ItemType) -> [String])? = nil
    var onItemSelected: ((ItemType) -> Void)? = nil
    
    @Namespace private var animation
    @State private var selectedItem: ItemType? = nil
    @State private var isNavigating = false
    
    public var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items) { item in
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedItem = item
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onItemSelected?(item)
                                    }
                                }
                            }) {
                                GeometryReader { proxy in
                                    let cardSize = proxy.size
                                    let minX = min(proxy.frame(in: .scrollView).minX * 1.5, proxy.size.width * 1.5)
                                    
                                    Image(imageForItem(item))
                                        .resizable()
                                        .scaledToFill()
                                        .offset(x: minX / 8 - 16)
                                        .frame(width: cardSize.width, height: cardSize.height, alignment: .center)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            TextView(
                                                title: titleForItem(item),
                                                subTitle: subTitleForItem(item),
                                                tags: tagsForItem?(item) ?? []
                                            )
                                            .matchedGeometryEffect(id: "text_\(item.id)", in: animation, isSource: true)
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.black.opacity(0.4), lineWidth: 2)
                                        )
                                        .shadow(radius: 8)
                                        .matchedGeometryEffect(id: "image_\(item.id)", in: animation, isSource: true)
                                }
                                .contentShape(Rectangle())
                                .scrollIndicators(.hidden)
                                .scrollTargetLayout()
                                .frame(width: size.width * 0.72, height: size.height)
                                .scaleEffect(0.95)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.84)
                                        .blur(radius: phase.isIdentity ? 0 : 1.2)
                                        .brightness(phase.isIdentity ? 0 : -0.2)
                                        .rotation3DEffect(
                                            phase.isIdentity ? .degrees(0.0) : .degrees(12.0),
                                            axis: phase.isIdentity ? (x: 0, y: 0, z: 0) : (x: 0, y: 2, z: 0)
                                        )
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .padding()
                }
            }
        }
    }
}

struct TextView: View {
    var title: String
    var subTitle: String
    var tags: [String] = []

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    .clear, .clear,
                    .black.opacity(0.1), .black.opacity(0.2), .black
                ],
                startPoint: .top, endPoint: .bottom
            )
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Outfit", size: 24))
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .padding(2)
                        .background(.black.opacity(0.6))
                        .cornerRadius(4)
                    
                    Text(subTitle)
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(2)
                        .background(.black.opacity(0.6))
                        .cornerRadius(2)
                        .lineLimit(2)
                    
                    if !tags.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(tags.prefix(2), id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.blue.opacity(0.7))
                                    .cornerRadius(12)
                            }
                            
                            if tags.count > 2 {
                                Text("+\(tags.count - 2)")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.gray.opacity(0.7))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    Explore()
}
