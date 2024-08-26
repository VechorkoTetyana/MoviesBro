import UIKit
import DesignSystem
import MoviesBroAuthentication
import MoviesBroSettings
import Swinject

class TabBarController: UITabBarController {

    private let container: Container

    init(container: Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .white
        tabBar.barTintColor = .green
        tabBar.tintColor = .blue
    }

    private func setupViewControllers() {
        let chats = UIViewController()
        chats.tabBarItem = Tab.chats.tabBarItem

        let calls = UIViewController()
        calls.tabBarItem = Tab.calls.tabBarItem

        viewControllers = [
            calls,
            chats,
            setupSettings()
        ]
    }

    private func setupSettings() -> UIViewController {
        let navigationController = UINavigationController()
        let coordinator = SettingsCoordinator(
            navigationController: navigationController,
            container: container
        )

        coordinator.start()

        coordinator.rootViewController.tabBarItem = Tab.settings.tabBarItem
        coordinator.rootViewController.title = Tab.settings.tabBarItem.title

        return navigationController
    }
}