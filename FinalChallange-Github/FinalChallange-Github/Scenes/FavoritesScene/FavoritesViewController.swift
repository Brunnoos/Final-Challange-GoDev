//
//  FavoritesViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    var viewModel = FavoritesViewModel()
    
    // MARK: - Fileprivate Properties
    
    fileprivate enum ViewState {
        case loading
        case normal
        case zeroResults
    }
    
    fileprivate var state: ViewState = .normal {
        didSet {
            setupView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {try getRepo()} catch{fatalError()}
        tableView.reloadData()

    }
    
    
    
    // MARK: - Private Properties
    
    private var repositories: [Repository]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var refreshControl = UIRefreshControl()


    // MARK: - Setup View State
    
    private func setupView() {
        switch state {
        case .loading:
            onLoadingState()
        case .normal:
            onNormalState()
        case .zeroResults:
            onZeroResultsState()
        }
    }
    
    // MARK: - Open Repository Detail Methods
    
    private func openRepoDetail(repository: Repository) {
        let detailsView = RepoDetailsViewController()
        
        detailsView.setRepository(repo: repository)
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
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
    
    private func onLoadingState() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.tableView.isHidden = true
        }
    }
    
    private func onNormalState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = false
            
        }
    }
    
    private func onZeroResultsState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = true
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        setupPullToRefreshTableView()
        do {try getRepo()} catch{fatalError()}

    }
    
    func getRepo() throws {
         self.repositories =  try viewModel.getRepositories()
    }
    
    // MARK: - Pull To Refresh Setup
    
    private func setupPullToRefreshTableView() {
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .black
        
        tableView.refreshControl = refreshControl
        
    }
    
    @objc private func onPullToRefresh() {
        do {try getRepo()} catch{fatalError()}
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Layout Setups
    
    private func setupLayouts() {
        setupTableViewLayout()
        setupLoadingIndicatorLayout()
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource, RepositoryTableViewCellDelegate {
    
    func saveFavoriteRepo(indexPath: IndexPath) {
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
            do {try getRepo()} catch{fatalError()}
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
            return repositories.count /// Additional Cell for LoadMoreCell
        } else {
            return 0
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let repositories = self.repositories {
            /// Repository Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
            
            let repository = repositories[indexPath.row]
           cell.setupCell(repository: repository, isFavorite: true, delegate: self)
            
            return cell
        }
        return UITableViewCell()
    }
}
