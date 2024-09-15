import Foundation

public struct Movie: Codable {
    public let id: Int
    public let overview: String?
    public let posterPath: String?
    public let releaseDate: String
    public let title: String?
    
    init(
        id: Int,
        overview: String?,
        posterPath: String?,
        releaseDate: String,
        title: String?
    ) {
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

