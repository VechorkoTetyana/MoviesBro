import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseData: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case releaseData = "releas_data"

    }
}
