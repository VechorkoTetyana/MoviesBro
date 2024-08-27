import UIKit
import DesignSystem
import SnapKit
import MoviesBroCore

public final class SettingsViewController: UIViewController {
   
    private var tableView: UITableView!
    public var viewModel: SettingsViewModel!
    private var footerView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        setupNavigationBar()
        
        view.layoutIfNeeded()
        styleFooterButton(in: footerView)
        
        viewModel.didUpdateHeader = { [weak self] in
            self?.tableView.reloadRows(at: [
                IndexPath(row: 0, section: 0)],
                with: .automatic)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsHeaderCell.self, forCellReuseIdentifier: SettingsHeaderCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.setMoviesBroTitle("Settings")
        
        setupEditBarButton()
        setupNavigationBackButton()

    }
    
    private func setupNavigationBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func setupEditBarButton() {
        let rightBarButtonItem = UIBarButtonItem(image: .editIcon, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButtonItem.tintColor = UIColor.darkRed
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func rightBarButtonTapped() {
//        presentProfile()
/*        let coordinator = ProfileCoordinator(navigationController: navigationController!, container: viewModel.container)
        coordinator.start() 
 
 let profileCoordinator = ProfileCoordinator(navigationController: self.navigationController!, container: viewModel.container)
    profileCoordinator.start()
 */
        
        viewModel.presentProfileEdit()
    }
}

extension SettingsViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        setupTableView()
        configureTableView()
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView = tableView
        tableView.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        
        self.footerView = setupTableFooter()
    }
    
    private func setupTableFooter() -> UIView {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        let button = UIButton(type: .custom)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        footerView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(306)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-37)
        }
        
        return footerView
    }
    
    private func styleFooterButton(in footerView: UIView) {
        if let button = footerView.subviews.compactMap({ $0 as? UIButton }).first {
            button.styleMoviesBro()
        }
    }
      
    @objc
    private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
            self?.didConfirmLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func didConfirmLogout() {
        do {
            try viewModel.logout()
        } catch {
            showError(error.localizedDescription)
        }
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
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableView.frame.height - view.safeAreaInsets.bottom - 108
    }
    
/*    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }*/
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presentProfile()
        
        viewModel.presentProfileEdit()
    }
}



