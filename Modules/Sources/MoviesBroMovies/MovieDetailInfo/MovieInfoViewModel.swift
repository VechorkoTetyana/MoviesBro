import Foundation
import Swinject

class MovieInfoViewModel {
    let movie: Movie
    var movieDetail: MovieDetail?
    private let coordinator: MovieInfoCoordinator
    private let container: Container
    private var repository: MoviesService {
        container.resolve(MoviesService.self)!
    }

    init(
        movie: Movie,
        coordinator: MovieInfoCoordinator,
        container: Container
    ) {
        self.movie = movie
        self.coordinator = coordinator
        self.container = container
    }
    
    func fetch() async throws {
        movieDetail = try await repository.fetchMovieDetails(id: movie.id)
    }
}
