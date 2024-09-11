import Foundation
import MoviesBroMovies

class DIContainer {
    let movieRepository: MoviesService
    
    init(movieRepository: MoviesService) {
        self.movieRepository = movieRepository
    }
}
