import UIKit
import Swinject

public protocol MoviesService {
    func fetchPopularMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
    func fetchMovieDetails(id: Int) async throws -> MovieDetail
}

public final class MoviesViewModel {
    private let container: Container
    private let coordinator: MoviesCoordinator
    private var repository: MoviesService {
        container.resolve(MoviesService.self)!
    }

    private var movieSource: [Movie] = []
    var movies: [Movie] = []
    var sectionTitles: [String] = []

    public init(
        container: Container,
        coordinator: MoviesCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
    }

    public func fetch() async throws {
        movieSource = try await repository.fetchPopularMovies()

        updateMovies(with: movieSource)    }
    
    func search(with query: String) {
        guard !query.isEmpty else {
            updateMovies(with: movieSource)

            return
        }
        
        let searchResults = movieSource.filter {
            if let overview = $0.overview {
                return $0.title!.lowercased().contains(query.lowercased())
                || overview.contains(query)
            } else {
                return $0.title!.lowercased().contains(query.lowercased())
            }
        }
        
        didCompleteSearch(with: searchResults)
    }
    
    private func didCompleteSearch(with results: [Movie]) {
        self.movies = results
        
        sectionTitles = movies.map { $0.title ?? "Default Name" }.sorted()
    }

    func didSelectMovie(_ movie: Movie) {
        coordinator.showMovieDetails(for: movie)
    }
    
    private func updateMovies(with movies: [Movie]) {
        self.movies = movies
        sectionTitles = movies.map { $0.title ?? "" }.sorted()
    }
}
