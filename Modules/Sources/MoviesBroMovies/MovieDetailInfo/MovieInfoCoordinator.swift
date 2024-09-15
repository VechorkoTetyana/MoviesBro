import UIKit
import Swinject
import MoviesBroCore

public protocol MovieInfoCoordinator: Coordinator {
    func presentMovieDetails()
}

public final class MovieInfoCoordinatorLive: MovieInfoCoordinator {
    
    private let navigationController: UINavigationController
    private let container: Container
    private let movie: Movie

    public init(
        navigationController: UINavigationController,
        container: Container,
        movie: Movie
    ) {
        self.navigationController = navigationController
        self.container = container
        self.movie = movie
    }

    public func start() {
        let viewModel = MovieInfoViewModel(
            movie: movie,
            coordinator: self,
            container: container
        )
        let controller = MovieInfoViewController()
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func presentMovieDetails() {
        let coordinator = MovieInfoCoordinatorLive(
            navigationController: navigationController,
            container: container, 
            movie: movie
        )
        coordinator.start()
    }
}
