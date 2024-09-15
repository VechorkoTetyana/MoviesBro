import DesignSystem
import SnapKit
import UIKit

class MovieInfoViewController: UIViewController {
    private weak var tableView: UITableView!
    weak var backButtonContainer: UIView!

    var viewModel: MovieInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        updateUI()
        
        title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovie()
    }
    
    private func fetchMovie() {
        Task {
            do {
                try await viewModel.fetch()
                tableView.reloadData()
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(getStatusBarHeight())
            make.bottom.equalToSuperview()
        }

        self.tableView = tableView
    }

    private func getStatusBarHeight() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return 0 }

        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: MovieInfoCell.identifier)
    }

    private func updateUI() {
        tableView.reloadData()
    }
    
    @objc func cancelAction() {
           dismiss(animated: true)
       }
}

extension MovieInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieInfoCell.identifier, for: indexPath) as? MovieInfoCell
        else { return UITableViewCell() }

        cell.configure(with: viewModel.movie)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
