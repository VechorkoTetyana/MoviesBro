import UIKit
import SnapKit
import DesignSystem
import SDWebImage

enum MoviesStrings: String {
    case search = "Search"
    case moviesNotFound = "Movies not found"
    case moviesSection = "MOVIES"
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
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    private func setupNavigationBar() {
        navigationItem.setMoviesBroTitle("Movie Details")
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
        tableView.backgroundColor = .white
    }
    
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
        setupSearchController()
        setupTableView()
    }

    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.titleBig48
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = MoviesStrings.search.rawValue
        searchController.searchBar.tintColor = .darkRed

        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.tableView = tableView
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.search(with: searchText)
        tableView.reloadData()
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
