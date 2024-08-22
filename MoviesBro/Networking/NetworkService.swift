import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
}

protocol NetworkConfig {
    var baseUrl: URL { get }
    var headers: [String: String] { get }
}

protocol NetworkService {
//  func fetch<T: Decodable>(url: URL, headers: [String: String]) async throws -> T
//  func fetch<T: Decodable>(path: String) async throws -> T
    func fetch<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T
}

extension NetworkService {
    func fetch<T: Decodable>(path: String) async throws -> T {
        try await fetch(path: path, queryItems: [])
    }
}

class NetworkServiceLive: NetworkService {
    
    private let config: NetworkConfig
    
    init(config: NetworkConfig) {
        self.config = config
    }
    
    func fetch<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        
        var url = config.baseUrl.appending(path: path)
        
        url.append(queryItems: queryItems)
        
        var urlRequest = URLRequest(url: url)
        for (key, value) in config.headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
//      URLSession.shared.data(for: request)
        
        guard let httpResponce = response as? HTTPURLResponse else {
            throw NetworkError.serverError(0)
        }
        
        guard (200...299).contains(httpResponce.statusCode) else {
            throw NetworkError.serverError(httpResponce.statusCode)
        }
        
//        we need decoded data:
//        return try JSONDecoder().decode(MoviesResponce.self, from: data)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
