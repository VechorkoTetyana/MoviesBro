import UIKit
import Swinject
import MoviesBroCore

public protocol MoviesCoordinator: Coordinator {
    func showMovieDetails(for movie: Movie)
}

public final class MoviesCoordinatorLive: MoviesCoordinator {

    private let navigationController: UINavigationController
    private let container: Container

    public var rootViewController: UIViewController!

    public init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }

    public func start() {
        let controller = MoviesViewController()
        
        let viewModel = MoviesViewModel(
            container: container,
            coordinator: self
        )
        controller.viewModel = viewModel
        navigationController.setViewControllers([controller], animated: false)

        self.rootViewController = controller
        
//      navigationController.pushViewController(controller, animated: false)

    }

    public func showMovieDetails(for movie: Movie) {
        let coordinator = MovieInfoCoordinatorLive(
            navigationController: navigationController,
            container: container,
            movie: movie
        )
        coordinator.start()
    }
}

