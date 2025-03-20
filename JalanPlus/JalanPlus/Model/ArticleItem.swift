import SwiftUI

struct ArticleItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subTitle: String
    let image: String
    let tags: [String]
    let content: String

    static func createSubtitle(from content: String, maxLength: Int = 100) -> String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= maxLength {
            return trimmed
        }
        let truncated = trimmed.prefix(maxLength)
        return truncated + "..."
    }
}

func loadTextFromFile(named filename: String) -> String? {
    if let filePath = Bundle.main.path(forResource: filename, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            return content
        } catch {
            print("Error loading file: \(error)")
            return nil
        }
    }
    return nil
}
