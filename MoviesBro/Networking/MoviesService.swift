import Foundation
import MoviesBroMovies

extension Movie {
    func toDomain() -> MoviesBroMovies.Movie {
        .init(
            id: self.id,
            overview: self.overview!,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            title: self.title
        )
    }
}

class MoviesServiceLive: MoviesService {
    
    func fetchPopularMovies() async throws -> [MoviesBroMovies.Movie] {
        let path = "/movie/popular"
        let moviesResponse: MoviesResponce = try await networkService.fetch(path: path) // path = "/movie/popular"
        
        return moviesResponse.results.map {
            $0.toDomain()
        }
    }
    
    func searchMovies(query: String) async throws -> [MoviesBroMovies.Movie] {
        let encodeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
         
        let queryItem = URLQueryItem(name: "query", value: encodeQuery)
        
        let moviesResponse: MoviesResponce = try await networkService.fetch(
            path: "/search/movie",
            queryItems: [queryItem]
        )
       
        return moviesResponse.results.map {
            $0.toDomain()
        }
    }
    
    private let accessToken: String
    private let networkService: NetworkService

    init(
        accessToken: String,
        networkService: NetworkService
    ) {
        self.accessToken = accessToken
        self.networkService = networkService
    }
    
    func fetchMovieDetails(id: Int) async throws -> MoviesBroMovies.MovieDetail {
        try await networkService.fetch(path: "/movie/\(id)")
    }
}
