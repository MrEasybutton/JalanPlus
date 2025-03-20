import SwiftUI

struct Decade: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let description: String
}

let decades = [
    Decade(id: "1960s", title: "Independence", subtitle: "Birth of a Nation",
          description: "Singapore gained independence in 1965 under the leadership of Lee Kuan Yew."),
    Decade(id: "1970s", title: "Building", subtitle: "Foundation Years",
          description: "Rapid industrialization and public housing development transformed Singapore."),
    Decade(id: "1980s", title: "Growth", subtitle: "Economic Miracle",
          description: "Singapore emerged as one of Asia's economic tigers with rapid modernization."),
    Decade(id: "1990s", title: "Global City", subtitle: "International Hub",
          description: "Singapore established itself as a major financial and transportation center."),
    Decade(id: "2000s", title: "Innovation", subtitle: "New Frontiers",
          description: "Focus on biotechnology, arts, and integrated resorts broadened Singapore's appeal."),
    Decade(id: "2010s", title: "Smart Nation", subtitle: "Digital Future",
          description: "Technology initiatives and sustainable development shaped a forward-looking city."),
    Decade(id: "2020s", title: "Resilience", subtitle: "Overcoming Challenges",
          description: "Singapore demonstrated strength and unity in facing global challenges.")
]
