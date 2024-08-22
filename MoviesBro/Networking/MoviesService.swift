import Foundation

protocol MoviesService {
    func fetchPopularMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}

class MoviesServiceLive: MoviesService {
    
/*    private let baseUrl: URL
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }*/
    
    private let accessToken: String
    private let networkService: NetworkService

    init(
        accessToken: String,
        networkService: NetworkService
    ) {
        self.accessToken = accessToken
        self.networkService = networkService
    }
    
    func fetchPopularMovies() async throws -> [Movie] {
//      let url = URL(string: "https://api.themoviedb.org/3/tv/popular")! the last part must be "/movie/popular" - thats why!
        let path = "/movie/popular"
        
/*        let headers = [
            "Authorization": "Bearer \(accessToken)", - provided by the config
            "accept": "application/json"
        ] */
        
        let moviesResponse: MoviesResponce = try await networkService.fetch(path: path) // path = "/movie/popular"

        
/*        var urlRequest = URLRequest(url: url) // this have comment-making to avoid duplication things
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // we need decoded data:
        let moviesResponse = try JSONDecoder().decode(moviesResponse.self, from: data)
*/
        return moviesResponse.results
        
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let encodeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        
/*        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(encodeQuery)")!
        let headers = [
            "Authorization": "Bearer \(accessToken)",
            "accept": "application/json"
        ] */
        
//        let moviesResponse: MoviesResponce = try await networkService.fetch(url: url, headers: headers)

        
/*        var urlRequest = URLRequest(url: url)
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // we need decoded data:
        let moviesResponse = try JSONDecoder().decode(moviesResponse.self, from: data)
*/
        
        let queryItem = URLQueryItem(name: "query", value: encodeQuery)
        
//      let moviesResponse: MoviesResponce = try await networkService.fetch(path: "/search/movie?query=\(encodeQuery)")
        let moviesResponse: MoviesResponce = try await networkService.fetch(
            path: "/search/movie",
            queryItems: [queryItem]
        )
       
        return moviesResponse.results
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        try await networkService.fetch(path: "/movie/\(id)")
    }
}

