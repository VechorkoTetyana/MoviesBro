import Foundation

public struct MovieDetail: Codable {
    public let movieName: String?
    public let description: String?
    public let moviePictureUrl: URL?

    public init(
        movieName: String?,
        description: String?,
        moviePictureUrl: URL? = nil
    ) {
        self.movieName = movieName
        self.description = description
        self.moviePictureUrl = moviePictureUrl
    }
}
