//
//  ViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit

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
    
    // MARK: - Lazy Properties
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.color = .orange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        /// Register Cell nIb
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
        
        return tableView
    }()
    
    
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = . loading
        setupTableViewLayout()
        
        // REMOVE THIS AFTER THIS SCREENN IS UPDATED
        SearchAPI.shared.searchLanguage(searchParams: SearchParameters(language: "swift")) { response in
            
            switch response {
            case .success(let result):
                self.repositories = result.repositories
                self.state = .normal
            case .failure(let error):
                print(error)
                self.state = .error
            }
        }
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
    
    private func onErrorState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = true
        }
    }
    
    // MARK: - Table View Setup
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Open Repository Detail Methods
    
    private func openRepoDetail(repository: Repository) {
        let detailsView = RepoDetailsViewController()
        
        detailsView.setRepository(repo: repository)
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repositories = self.repositories {
            openRepoDetail(repository: repositories[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repositories = self.repositories {
            return repositories.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
        
        if let repositories = self.repositories {
            let repository = repositories[indexPath.row]
            cell.setupCell(repository: repository, isFavorite: false)
        }
        
        return cell
    }
    
    
}
