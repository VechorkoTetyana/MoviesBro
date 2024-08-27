import UIKit
import MoviesBroCore
import Swinject

public class SettingsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let container: Container
    
    public var rootViewController: UIViewController!
    
    public init(
        navigationController: UINavigationController,
        container: Container
    ) {
        self.navigationController = navigationController
        self.container = container
    }
    
    public func start() {
        let controller = SettingsViewController()
        controller.viewModel = SettingsViewModel(container: container, coordinator: self)
        navigationController.setViewControllers([controller], animated: true)
        
        rootViewController = controller
    }
    
    func presentProfileEdit() {
        /*
         let profileCoordinator = ProfileCoordinator(navigationController: self.navigationController!, container: viewModel.container)
            profileCoordinator.start()
         */
        
        let coordinator = ProfileCoordinator(
            navigationController: self.navigationController,
            container: container
        )
        coordinator.start()
    }
}
