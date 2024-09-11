import Foundation

class TMDBNetworkConfig: NetworkConfig {
    let baseUrl: URL = URL(string: "https://api.themoviedb.org/3")!
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(accessToken)",
            "accept": "application/json"
        ]
    }
    
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}


