import Foundation
import Swinject
import MoviesBroMovies

public class AppAssembly {

    let container: Container

    init(container: Container) {
        self.container = container
    }

    func assemble() {
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "TMDBAPIAccessToken") as! String
        
        let networkConfigLive = TMDBNetworkConfig(accessToken: accessToken)

        let networkService = NetworkServiceLive(config: networkConfigLive)
        
        let movieBroRepository = MoviesServiceLive(accessToken: accessToken, networkService: networkService)
    
        container.register(MoviesService.self) { container in
            movieBroRepository
        }
    }
}
