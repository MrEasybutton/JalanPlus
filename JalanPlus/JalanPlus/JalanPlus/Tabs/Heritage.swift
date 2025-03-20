import SwiftUI

struct Heritage: View {
    @State private var selectedDecade: String?
    @Environment(\.colorScheme) var colorScheme

    let redColor = Color(red: 0.92, green: 0.12, blue: 0.16)
    let whiteColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundLayer
            
            VStack(spacing: 0) {
                headerView
                ScrollView {
                    VStack(spacing: -20) {
                        ForEach(decades) { decade in
                            DecadeCard(
                                decade: decade,
                                isSelected: selectedDecade == decade.id,
                                redColor: redColor,
                                colorScheme: colorScheme,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedDecade = selectedDecade == decade.id ? nil : decade.id
                                    }
                                }
                            )
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var backgroundLayer: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color(red: 0.1, green: 0.0, blue: 0.0) : Color(red: 0.95, green: 0.95, blue: 0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var headerView: some View {
        ZStack {
            Rectangle()
                .fill(redColor)
                .frame(height: 140)

            HStack {
                HStack(spacing: 4) {
                    ForEach(1..<4) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .offset(x:CGFloat(-i), y:CGFloat((8-i*2)*(8-i*2)))
                    }
                }
                
                Image("sg60")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .shadow(radius: 16)
                
                HStack(spacing: 4) {
                    ForEach(1..<4) { j in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .offset(x:CGFloat(j), y:CGFloat((j*2)*(j*2)))
                    }
                }
            }
            .offset(y: 20)
        }
    }
}

struct DecadeCard: View {
    let decade: Decade
    let isSelected: Bool
    let redColor: Color
    let colorScheme: ColorScheme
    let onTap: () -> Void
    
    var cardBackground: Color {
        colorScheme == .dark ? Color.black.opacity(0.6) : Color.white
    }
    
    var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(redColor.opacity(0.7))
                .frame(width: 4, height: 20)

            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image(decade.id)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: isSelected ? 200 : 120)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [.clear, redColor.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    HStack(alignment: .bottom) {
                        Circle()
                            .fill(redColor)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? Color.black : Color.white)
                                    .frame(width: 36, height: 36)
                            )
                            .offset(x: -20)

                        Text(decade.id)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()

                        Text(decade.title)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, 15)
                    .padding(.leading, 30)
                }

                if isSelected {
                    VStack(alignment: .leading, spacing: 12) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<decade.imageNames.count) {j in
                                    Image(decade.imageNames[j]).resizable().scaledToFill()
                                        .frame(width: 320)
                                        .cornerRadius(10)
                                        .clipped()
                                        .overlay() {
                                            VStack {
                                                Spacer()
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.black.opacity(0.5))
                                                    .frame(width: 320, height: 130, alignment: .bottom).overlay() {
                                                        VStack {
                                                            HStack{
                                                                Text(decade.subtitles[j])
                                                                    .font(.system(size:24))
                                                                    .foregroundStyle(.white)
                                                                    .bold()
                                                                    
                                                                Spacer()
                                                            }.padding([.leading], 20).padding([.top], 8)
                                                            Text(decade.descriptions[j])
                                                                .font(.system(size:14))
                                                                .foregroundStyle(.white)
                                                                .padding([.leading], 16)
                                                                .frame(width: 300)
                                                            
                                                            Spacer()
                                                                
                                                        }
                                                    }
                                                    
                                            
                                            }
                                        }
                                }
                            }
                        }

                        HStack {
                            Spacer()
                            Image(systemName: "chevron.up")
                                .foregroundColor(redColor)
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.all, 20)
                    .background(cardBackground)
                }
            }
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 20)
            .onTapGesture(perform: onTap)

            Rectangle()
                .fill(redColor.opacity(0.7))
                .frame(width: 4, height: 20)
        }
    }
}

struct HeritageTimeline_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Heritage()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            Heritage()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
