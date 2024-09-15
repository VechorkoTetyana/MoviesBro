import UIKit
import DesignSystem
import Swinject
import MoviesBroCore
import MoviesBroMovies

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container!
    var coordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupContainer()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        UINavigationController.styleMovieBro()

        let accessToken = Bundle.main.object(forInfoDictionaryKey: "TMDBAPIAccessToken") as! String
        
        let networkConfigLive = TMDBNetworkConfig(accessToken: accessToken)

        let networkService = NetworkServiceLive(config: networkConfigLive)
        
        let service = MoviesServiceLive(accessToken: accessToken, networkService: networkService)
        
        
        Task {
            do {
                let movies = try await service.fetchPopularMovies()
                print(movies.count)
            } catch {
                print(error.localizedDescription)
            }
        }
        setupAppCoordinator()
    }
    
    private func setupAppCoordinator() {
        let navigationController = UINavigationController()

        let coordinator = AppCoordinator(
            navigationController: navigationController,
            container: container
        )

        coordinator.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        self.coordinator = coordinator
    }

    private func setupTabBar(navigationController: UINavigationController) -> UITabBarController {
        let moviesCoordinator = MoviesCoordinatorLive(
            navigationController: navigationController,
            container: container
        )
        
        let tabBarController = UITabBarController()
        
        let moviesViewController = MoviesViewController()
        moviesViewController.viewModel = MoviesViewModel(
            container: container,
            coordinator: moviesCoordinator
        )
        
        let moviesNavController = UINavigationController(rootViewController: moviesViewController)
        moviesNavController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        
        tabBarController.viewControllers = [moviesNavController]
        
        moviesCoordinator.start()
        
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

extension SceneDelegate {
    private func setupContainer() {
        container = Container()
        AppAssembly(container: container).assemble()
    }
}
