import UIKit
import SnapKit
import DesignSystem
import SDWebImage

enum MoviesStrings: String {
    case search = "Search"
}

public class MoviesViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: nil)
    }()
    
    private weak var tableView: UITableView!
    public var viewModel: MoviesViewModel!
            
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    private func configureTableView() {
        tableView.register(MoviesCell.self, forCellReuseIdentifier: "MoviesCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 16)
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 10
        } else {
            // Fallback on earlier versions
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "search.placeholder"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private func loadMovies() {
        Task {
            do {
                try await viewModel.fetch()
                await MainActor.run {
                    self.tableView.reloadData()
                }
            } catch {
                    showError(error.localizedDescription)
            }
        }
    }
}

extension MoviesViewController {

    private func setupUI() {
        setupNavigationTitle()
        setupTableView()
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.titleBig48
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.tableView = tableView
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionTitles.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as? MoviesCell else {
            return UITableViewCell()
        }

        let movie = viewModel.movies[indexPath.row]

        cell.configure(with: movie)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = viewModel.movies[indexPath.row]

        viewModel.didSelectMovie(movie)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("UISearchBarDelegate test")

        Task {
            await viewModel.searchMovies(query: searchText)
            tableView.reloadData()
        }
    }
}
