import SwiftUI

struct Heritage: View {
    let gradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: .black, location: 0),
            .init(color: .clear, location: 0.4)
        ]),
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack() {
                ForEach(years) {yearBox in
                    VStack() {
                        Image(yearBox.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: .infinity, height: 600)
                            .overlay(
                                ZStack(alignment: .bottom) {
                                    Image("ART_02")
                                        .resizable()
                                        .scaledToFill()
                                        .blur(radius: 25)
                                        .padding(-20)
                                        .clipped()
                                        .mask(gradient)
                                    
                                    gradient
                                }.offset(y: 10)
                            )
                            .scrollTransition() {
                                effect, phase in effect.scaleEffect(phase.isIdentity ? 1 : 0.5)
                            }
                            .overlay() {
                                ZStack() {
                                    Rectangle()
                                        .frame(width: 250,height: 100)
                                        .opacity(0.3)
                                        .blur(radius: 20)
                                    
                                    
                                    Text(yearBox.title).foregroundStyle(.white)
                                        .bold(true)
                                        .font(.system(size: 120))
                                    
                                }
                            }
                            
                            


                            
                    
                    Text("\(yearBox.subtext)").font(.system(size: 24))
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 420, height: .infinity, alignment: .top)
                        
                    
                    }
                }
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
}
#Preview {
    Heritage()
}
