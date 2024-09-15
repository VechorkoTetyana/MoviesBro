import UIKit
import MoviesBroMovies
import MoviesBroCore
import Swinject

class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let container: Container
    
    init(
        navigationController: UINavigationController,
        container: Container
    ) {
        self.navigationController = navigationController
        self.container = container
        
        UINavigationController.styleMovieBro()
    }
    
    func start() {
        let moviesCoordinator = MoviesCoordinatorLive(
            navigationController: navigationController,
            container: container
        )
        moviesCoordinator.start()
        
        navigationController.setViewControllers([setupTabBar()], animated: false)
    }
    
    private func setupTabBar() -> UIViewController {
        let moviesCoordinator = MoviesCoordinatorLive(
            navigationController: navigationController,
            container: container
        )
        
        let tabBarController = TabBarController(
            container: container,
            coordinator: moviesCoordinator
        )
        
        moviesCoordinator.start()
        
        return tabBarController
    }
}

