import SwiftUI
import Liquor

struct ContentView: View {
    @State private var selectedTab: AppTab = .heritage
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        Spacer()
        Aquaporin(activeTab: $selectedTab, configuration: AquaporinConfiguration(inactiveTint: .black.opacity(0.4), backgroundGradient: LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: .red.opacity(0.8), shadowRadius: 0.2))
    }
}

#Preview {
    ContentView()
}
