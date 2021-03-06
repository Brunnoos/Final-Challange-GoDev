//
//  ViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    // MARK: - Fileprivate Properties
    
    fileprivate enum ViewState {
        case loading
        case normal
        case error
        case zeroResults
    }
    
    fileprivate var state: ViewState = .normal {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private Properties
    
    private var repositories: [Repository]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var favoritesRepositories: [Repository]?
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Public Properties
    
    var viewModel: SearchViewModel?
    
    var searchText: String?
    var searchOrder: SearchOrder = .descendent
    
    // MARK: - Lazy Properties
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        /// Register Cells
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
        tableView.register(LoadMoreTableViewCell.self, forCellReuseIdentifier: LoadMoreTableViewCell.identifier)
        
        return tableView
    }()
    
    lazy var searchViewController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        return controller
    }()
    
    lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.icloud")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var errorTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var zeroResultsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.icloud")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var zeroResultsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Nenhum resultado foi encontrado para a busca"
        return label
    }()
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SearchViewModel()
        viewModel?.delegate = self
        
        setupLayouts()
        setupSearchController()
        setupPullToRefreshTableView()
        
        defaultSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
        setupSearchOrderNavButton()
        
        if let tableViewSelected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: tableViewSelected, animated: true)
        }
     
        getRepo()
        tableView.reloadData()
    }
    
    func getRepo() {
        self.favoritesRepositories = viewModel?.getFavorityRepositories()
    }
    
    // MARK: - Navigation Controller Setup
    
    private func setupNavigationController() {
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
    }
    
    private func setupSearchOrderNavButton() {
        let switchOrderButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.square"), style: .plain, target: self, action: #selector(onSwitchSearchOrder))
        
        navigationItem.rightBarButtonItems = [switchOrderButton]
    }
    
    // MARK: - Search Controller Setup
    
    private func setupSearchController() {
        searchViewController.searchBar.autocapitalizationType = .none
        searchViewController.searchBar.autocorrectionType = .no
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.automaticallyShowsCancelButton = false
        
        searchViewController.searchResultsUpdater = self
        searchViewController.delegate = self
        searchViewController.searchBar.delegate = self
        
        searchViewController.searchBar.clearsContextBeforeDrawing = false
        
        searchViewController.searchBar.sizeToFit()
        searchViewController.searchBar.placeholder = "Pesquisa"
    }
    
    // MARK: - Setup View State
    
    private func setupView() {
        switch state {
        case .loading:
            onLoadingState()
        case .normal:
            onNormalState()
        case .zeroResults:
            onZeroResultsState()
        case .error:
            onErrorState()
        }
    }
    
    
    private func onLoadingState() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.tableView.isHidden = true
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            self.zeroResultsImageView.isHidden = true
            self.zeroResultsTextLabel.isHidden = true
        }
    }
    
    private func onNormalState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            self.zeroResultsImageView.isHidden = true
            self.zeroResultsTextLabel.isHidden = true
        }
    }
    
    private func onZeroResultsState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = true
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            self.zeroResultsImageView.isHidden = false
            self.zeroResultsTextLabel.isHidden = false
        }
    }
    
    private func onErrorState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = true
            self.errorImageView.isHidden = false
            self.errorTextLabel.isHidden = false
            self.zeroResultsImageView.isHidden = true
            self.zeroResultsTextLabel.isHidden = true
        }
    }
    
    // MARK: - Pull To Refresh Setup
    
    private func setupPullToRefreshTableView() {
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .black
        
        tableView.refreshControl = refreshControl
    }
    
    @objc private func onPullToRefresh() {
        onSearch()
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Search Methods
    
    private func defaultSearch() {
        searchText = "swift"
        onSearch()
    }
    
    private func onSearch() {
        if let searchText = searchText {
            state = . loading
            
            var search = SearchParameters(language: searchText)
            search.order = searchOrder
            viewModel?.fetchSearch(searchParam: search)
        }
    }
    
    private func onSearchMore() {
        if let searchText = searchText {
            var search = SearchParameters(language: searchText)
            search.order = searchOrder
            viewModel?.fetchMoreSearch(searchParam: search)
        }
    }
    
    @objc private func onSwitchSearchOrder() {
        if searchOrder == .descendent {
            searchOrder = .ascendent
            
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "chevron.up.square")
            }
        } else {
            searchOrder = .descendent
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "chevron.down.square")
            }
        }
        
        onSearch()
    }

    // MARK: - Open Repository Detail Methods
    
    private func openRepoDetail(repository: Repository) {
        let detailsView = RepoDetailsViewController()
        
        detailsView.setRepository(repo: repository)
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    // MARK: - Layout Setups
    
    private func setupLayouts() {
        setupTableViewLayout()
        setupLoadingIndicatorLayout()
        
        setupErrorImageLayout()
        setupErrorTextLayout()
        
        setupZeroResultsImageLayout()
        setupZeroResultsTextLayout()
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupLoadingIndicatorLayout() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupErrorImageLayout() {
        view.addSubview(errorImageView)
        
        NSLayoutConstraint.activate([
            errorImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 48),
            errorImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupErrorTextLayout() {
        view.addSubview(errorTextLabel)
        
        NSLayoutConstraint.activate([
            errorTextLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 12),
            errorTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupZeroResultsImageLayout() {
        view.addSubview(zeroResultsImageView)
        
        NSLayoutConstraint.activate([
            zeroResultsImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
            zeroResultsImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            zeroResultsImageView.heightAnchor.constraint(equalToConstant: 48),
            zeroResultsImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupZeroResultsTextLayout() {
        view.addSubview(zeroResultsTextLabel)
        
        NSLayoutConstraint.activate([
            zeroResultsTextLabel.topAnchor.constraint(equalTo: zeroResultsImageView.bottomAnchor, constant: 12),
            zeroResultsTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            zeroResultsTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            zeroResultsTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

}

// MARK: - Search Delegate Methods

extension SearchViewController: SearchServiceDelegate {
    func onSearchCompleted(isAdditional: Bool) {
        if let viewModel = viewModel {
            let foundRepositories = viewModel.getRepositories()
            
            self.favoritesRepositories = viewModel.getFavorityRepositories()
            
            if let foundRepositories = foundRepositories {
                
                if isAdditional, var currentRepositories = self.repositories {
                    
                    currentRepositories.append(contentsOf: foundRepositories)
                    repositories = currentRepositories
                    
                } else if !isAdditional {
                    
                    if foundRepositories.count > 0 {
                        repositories = foundRepositories
                        state = .normal
                    } else {
                        state = .zeroResults
                    }
                    
                }
            }
        }
    }
    
    func onSearchError(error: String) {
        errorTextLabel.text = error
        state = .error
    }
}

// MARK: - Table View Extension Methods

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, RepositoryTableViewCellDelegate {
    func saveFavoriteRepo(indexPath: IndexPath) {
        guard let repositories = self.repositories else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let repositoriesEntity = NSEntityDescription.entity(forEntityName: "GitRepo", in: persistanceContainer.viewContext)!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GitRepo")
        
        if let favoritesRepositories = self.favoritesRepositories {
            for item in favoritesRepositories {
                if repositories[indexPath.item].fullName == item.fullName {
                    do {
                        request.predicate = NSPredicate(format: "fullName = %@", "\(item.fullName)")
                        let data =  try persistanceContainer.viewContext.fetch(request)
                        for object in data {
                            persistanceContainer.viewContext.delete(object as! NSManagedObject)
                        }
                        try persistanceContainer.viewContext.save()
                        self.favoritesRepositories = viewModel?.getFavorityRepositories()
                        tableView.reloadData()
                    } catch {
                        return
                    }
                }
            }
        }
        
        let rep = NSManagedObject(entity: repositoriesEntity, insertInto: persistanceContainer.viewContext)
        rep.setValue(repositories[indexPath.item].id, forKey: "id")
        rep.setValue(repositories[indexPath.item].nodeID, forKey: "nodeID")
        rep.setValue(repositories[indexPath.item].name, forKey: "name")
        rep.setValue(repositories[indexPath.item].fullName, forKey: "fullName")
        rep.setValue(repositories[indexPath.item].itemPrivate, forKey: "itemPrivate")
        rep.setValue(repositories[indexPath.item].owner.login, forKey: "ownerLogin")
        rep.setValue(repositories[indexPath.item].owner.id, forKey: "ownerId")
        rep.setValue(repositories[indexPath.item].owner.nodeID, forKey: "ownerNodeID")
        rep.setValue(repositories[indexPath.item].owner.avatarURL, forKey: "ownerAvatarURL")
        rep.setValue(repositories[indexPath.item].owner.htmlURL, forKey: "ownerHtmlURL")
        rep.setValue(repositories[indexPath.item].itemDescription, forKey: "itemDescription")
        rep.setValue(repositories[indexPath.item].createdAt, forKey: "createdAt")
        rep.setValue(repositories[indexPath.item].watchers, forKey: "watchers")
        rep.setValue(repositories[indexPath.item].htmlURL, forKey: "htmlURL")
        
        try? persistanceContainer.viewContext.save()
    }
    
    func deleteFavoriteRepo(indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GitRepo")
        
        do {
            request.predicate = NSPredicate(format: "fullName = %@", "\(self.repositories![indexPath.row].fullName)")
            let data =  try persistanceContainer.viewContext.fetch(request)
            for object in data {
                persistanceContainer.viewContext.delete(object as! NSManagedObject)
            }
            try persistanceContainer.viewContext.save()
            getRepo()
            tableView.reloadData()

        } catch {
                
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repositories = self.repositories {
            if indexPath.row < repositories.count {
                /// Has clicked on a repository
                openRepoDetail(repository: repositories[indexPath.row])
            } else {
                /// Has clicked on Load More Cell
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repositories = self.repositories {
            return repositories.count + 1 /// Additional Cell for LoadMoreCell
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let repositories = self.repositories, indexPath.row < repositories.count {
            /// Repository Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
            
            let repository = repositories[indexPath.row]
            var isFavorite = false
            
            if let favoritesRepositories = self.favoritesRepositories {
                for item in favoritesRepositories {
                    if item.fullName == repository.fullName {
                        isFavorite = true
                    }
                }
            }
            
            cell.setupCell(repository: repository, isFavorite: isFavorite, delegate: self)
            
            return cell
        } else {
            /// Load More Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadMoreTableViewCell.identifier, for: indexPath) as? LoadMoreTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup()
            cell.startLoadingIndicator()
            onSearchMore()
            
            return cell
        }
    }
}


// MARK: - Search Controller Extension Methods

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            searchText = searchBarText
            onSearch()
            
            searchBar.endEditing(true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
