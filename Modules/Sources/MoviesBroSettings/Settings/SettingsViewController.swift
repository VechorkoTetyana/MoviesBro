import UIKit
import DesignSystem
import SnapKit
import MoviesBroCore

public final class SettingsViewController: UIViewController {
   
    private weak var tableView: UITableView!
    
    public var viewModel: SettingsViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        
        viewModel.didUpdateHeader = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        Task {
            do {
                try await viewModel.fetchUserProfile()
            } catch {
                showError(error.localizedDescription)
            }
        }
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsHeaderCell.self, forCellReuseIdentifier: SettingsHeaderCell.identifier)
    }
}

extension SettingsViewController {
    
    private func setupUI() {
        setupNavigationTitle()
        setupTableView()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.titleLit
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        self.tableView = tableView
    }
}

extension SettingsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHeaderCell.identifier, for: indexPath) as? SettingsHeaderCell else { return UITableViewCell() }
        
        cell.configure(with: viewModel.header)
        
    return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.presentProfileEdit()
    
    /*    private func presentProfileEdit() {
        viewModel.presentProfileEdit()
        
       let coordinator = ProfileEditCoordinator(navigationController: navigationController!, container: viewModel.container)
        
        coordinator.start()
        
                let viewModel = ProfileEditViewModel(
                
                    container: viewModel.container
                    
              /*  authService: viewModel.authService,
                  userRepository: viewModel.userRepository,
                  profilePictureRepository: viewModel.profilePictureRepository */
            )
            
            let controller = ProfileEditViewController()
            controller.viewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
      */
        
    }
}
