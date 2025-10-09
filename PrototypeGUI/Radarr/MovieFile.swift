import Foundation

struct MovieFile: Identifiable, Hashable {
    let id = UUID()
    let relativePath: String
    let type: String
    let `extension`: String
    let size: String?
    let video: String?
    let audio: String?
    let languages: [String]?
    let quality: String?
    let formats: [String]?
    let addedOn: Date?
}

extension MovieFile {
}

