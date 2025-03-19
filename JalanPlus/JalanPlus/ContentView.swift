import SwiftUI
import Liquor

struct ContentView: View {
    @State private var selectedTab: AppTab = .heritage
    
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
        .ignoresSafeArea(.keyboard)
        
        Spacer()
        Aquaporin(activeTab: $selectedTab, configuration: AquaporinConfiguration(inactiveTint: .black.opacity(0.4), backgroundGradient: LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: .red.opacity(0.8), shadowRadius: 0.2))
            .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
}
