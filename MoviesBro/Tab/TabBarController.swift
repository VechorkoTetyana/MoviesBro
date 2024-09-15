import UIKit
import DesignSystem
import Swinject
import MoviesBroMovies

class TabBarController: UITabBarController {

    private let container: Container
    private let coordinator: MoviesCoordinator
    
    init(container: Container, coordinator: MoviesCoordinator) {
        self.container = container
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        setupViewControllers()
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
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = .darkRed
        tabBar.unselectedItemTintColor = .gray
    }

    private func setupViewControllers() {
        let chats = UIViewController()
        chats.tabBarItem = Tab.chats.tabBarItem

        let home = MoviesViewController()
        home.viewModel = .init(
            container: container,
            coordinator: coordinator
        )
        home.tabBarItem = Tab.home.tabBarItem

        viewControllers = [
            home,
            chats
        ]
    }
}
