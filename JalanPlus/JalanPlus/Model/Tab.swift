import SwiftUI
import Liquor

public enum AppTab: String, TabItem {
    case explore = "Explore"
    case heritage = "Heritage"
    case connect = "Connect"
    
    public var icon: String {
        switch self {
        case .explore: return "figure.walk.motion"
        case .heritage: return "heart.circle"
        case .connect: return "figure.stand.line.dotted.figure.stand"
        }
    }
}


#Preview {
    ContentView()
}
