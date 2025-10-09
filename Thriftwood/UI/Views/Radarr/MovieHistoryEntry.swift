import SwiftUI

// Shared model for movie history entries used by MovieHistoryView
struct HistoryEntry: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let dateDescription: String
    let statusText: String?
    let statusColor: Color?
    let badges: [String]
    let details: [(String, String)]
}
