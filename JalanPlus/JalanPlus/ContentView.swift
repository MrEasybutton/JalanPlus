import SwiftUI
import Liquor

struct ContentView: View {
    @State private var selectedTab: AppTab = .heritage
    @State private var isLoggedIn = false
    @AppStorage("userPoints") var storedPoints: Int = 0
    @State private var points: Int = 0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if isLoggedIn {
                mainView
            } else {
                LoadingView()
            }
        }
        .onAppear {
            points = storedPoints
            
            Task {
                await UserManager.shared.checkAuthStatus()
                
                if let userID = UserManager.shared.userID {
                    isLoggedIn = true
                    print("Restored existing session for user: \(userID)")
                    
                    let serverPoints = await SupabaseManager.shared.getUserPoints(userId: UUID(uuidString: userID)!)
                    if serverPoints > 0 {
                        points = serverPoints
                        storedPoints = serverPoints
                    } else if storedPoints > 0 {
                        let success = await SupabaseManager.shared.updateUserPoints(userId: UUID(uuidString: userID)!, points: storedPoints)
                        points = storedPoints
                        print("Updated server with local points: \(storedPoints), success: \(success)")
                    }
                } else {
                    signInAnonymously()
                }
            }
        }
    }

    private func signInAnonymously() {
        UserManager.shared.signInAnonymously { success in
            if success {
                isLoggedIn = true
                
                Task {
                    if let userID = UserManager.shared.userID {
                        if storedPoints > 0 {
                            let success = await SupabaseManager.shared.updateUserPoints(userId: UUID(uuidString: userID)!, points: storedPoints)
                            points = storedPoints
                            print("New sign-in with existing points: \(storedPoints), server update success: \(success)")
                        } else {
                            let serverPoints = await SupabaseManager.shared.getUserPoints(userId: UUID(uuidString: userID)!)
                            points = serverPoints
                            storedPoints = serverPoints
                            print("New sign-in with no stored points, server points: \(serverPoints)")
                        }
                    }
                }
            }
        }
    }

    private var mainView: some View {
        VStack {
            if selectedTab == .heritage {
                Heritage()
            } else if selectedTab == .explore {
                Explore()
            } else if selectedTab == .connect {
                Connect()
            } else {
                Text("???")
            }

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
            .offset(y: -30)
            .ignoresSafeArea(.keyboard)
        }
        .offset(y: 10)
        .ignoresSafeArea()
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading SG60 App...")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
