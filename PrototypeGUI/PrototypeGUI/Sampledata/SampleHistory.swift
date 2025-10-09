import SwiftUI
import Foundation

// Sample history entries for previews. All sample data should live under Sampledata.
// This builds a map of sample history entries per movie title. Each movie receives
// 1–5 entries to exercise various UI states.
let sampleHistoryEntries: [HistoryEntry] = []

let movieFilesSampleHistory: [String: [HistoryEntry]] = {
    var map: [String: [HistoryEntry]] = [:]

    // Defensive: if Movie.sample is not available, return empty map
    let movies = Movie.sample

    let statusOptions: [(String, Color, [String])] = [
        ("Movie Imported (Bluray-1080p)", .mint, ["Movie Imported", "1080p", "No-RlsGroup", "x264"]),
        ("Movie File Deleted", .red, []),
        ("Grabbed from Sample Indexer", .orange, ["1080p", "No-RlsGroup", "x264"]),
        ("Renamed by Agent", .blue, []),
        ("Library Scan: matched", .gray, [])
    ]

    for (i, movie) in movies.enumerated() {
        var entries: [HistoryEntry] = []
        let count = 1 + (i % 5) // 1..5 entries per movie

        for j in 0..<count {
            let statusIndex = (i + j) % statusOptions.count
            let (statusText, statusColor, badges) = statusOptions[statusIndex]

            let title = (statusText == "Movie File Deleted") ? "/data/media/Films/\(movie.title) (\(movie.year)) {tmdb-...}" : "\(movie.title) \(movie.year) Entry \(j+1)"

            let subtitle: String
            if j == 0 {
                subtitle = "4 Months Ago · June \(1 + ((i + j) % 28)), 2025 · 03:36:\(10 + j)"
            } else {
                subtitle = "\((j) * 3) Days Ago · June \(1 + ((i + j) % 28)), 2025"
            }

            let dateDescription = subtitle

            var details: [(String, String)] = []
            if statusText == "Movie Imported (Bluray-1080p)" {
                details.append(("QUALITY", movie.quality ?? "WEB-1080p"))
                details.append(("LANGUAGES", (movie.files?.first?.languages?.joined(separator: "\n") ?? "English")))
                details.append(("INDEXER", "Sample Indexer"))
                details.append(("CLIENT", "SABnzbd"))
                details.append(("AGE", "\((i * 100) % 1000) Days Ago"))
                details.append(("PUBLISHED DATE", "April \(1 + ((i + j) % 28)), 2023\n21:21:54"))
                details.append(("INFO URL", "https://example.org/details/sample-\(i)-\(j)"))
            }

            let entry = HistoryEntry(
                title: title,
                subtitle: subtitle,
                dateDescription: dateDescription,
                statusText: statusText,
                statusColor: statusColor,
                badges: badges,
                details: details
            )

            entries.append(entry)
        }

        map[movie.title] = entries
    }

    return map
}()
