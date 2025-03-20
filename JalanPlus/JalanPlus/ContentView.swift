import SwiftUI
import Liquor

struct ContentView: View {
    @State private var selectedTab: AppTab = .heritage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if selectedTab == .heritage {
                Heritage()
            } else if selectedTab == .explore {
                Explore()
            } else if selectedTab == .connect {
                Connect()
            } else {
                VStack {
                    Text("???")
                }
            }
        }
        .offset(y: 10)
        .ignoresSafeArea()
        
        Spacer()
        Aquaporin(
            activeTab: $selectedTab,
            configuration: AquaporinConfiguration(
                inactiveTint: colorScheme == .dark ? .white.opacity(0.4) : .black.opacity(0.4),
                backgroundGradient: LinearGradient(
                    colors: [
                        colorScheme == .dark ? Color.black : Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                shadowColor: colorScheme == .dark ? Color.red.opacity(0.6) : Color.red.opacity(0.8),
                shadowRadius: 0.2,
                animationResponse: 0.45,
                animationBlendDuration: 0.2
            )
        )
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
}
