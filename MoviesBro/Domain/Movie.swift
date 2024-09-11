import Foundation
/*
struct MovieX: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseData: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        

    }
 
 
 public struct Movie: Codable {
     public let id: Int
     public let overview: String?
     public let posterPath: String?
     public let firstAirDate: String
     public var name: String?
     
     public init(
                 id: Int,
                 overview: String,
                 posterPath: String?,
                 firstAirDate: String,
                 name: String? = nil
     ) {
         self.id = id
         self.overview = overview
         self.posterPath = posterPath
         self.firstAirDate = firstAirDate
         self.name = name
     }
 }


}*/

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

