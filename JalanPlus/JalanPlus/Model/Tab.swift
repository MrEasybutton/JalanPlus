import SwiftUI
import Liquor

public enum AppTab: String, TabItem {
    case home = "Stable"
    case services = "nothing"
    case partners = "sucks"
    
    public var icon: String {
        switch self {
        case .home: return "face.smiling"
        case .services: return "questionmark.folder.fill"
        case .partners: return "exclamationmark.triangle.fill"
        }
    }
}
