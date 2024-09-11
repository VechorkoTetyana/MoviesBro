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
        
        title = "Presented View"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))

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
        setupBackButton()
    }
    
    private func setupBackButton() {
        let container = UIView()
        container.isUserInteractionEnabled = true
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .darkRed

        button.isUserInteractionEnabled = true
        view.bringSubviewToFront(container)

        
        button.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        
        
        container.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
            
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview()
        }
        
        self.backButtonContainer = container
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackBtn))
    }
    
    @objc
    private func didTapBackBtn() {
        print("Back button tapped")
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
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
