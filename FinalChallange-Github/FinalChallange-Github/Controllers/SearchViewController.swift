//
//  ViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit

class SearchViewController: UIViewController {

    private lazy var repositories = [Repository]() {
        didSet {
            if repositories.count > 0 {
                self.openRepoDetail(repository: repositories[0])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SearchAPI.shared.searchLanguage(searchParams: SearchParameters(language: "swift")) { response in
            
            switch response {
            case .success(let result):
                self.repositories = result.repositories
            case .failure(let error):
                print(error)
            }
        }
    }

    private func openRepoDetail(repository: Repository) {
        let detailsView = RepoDetailsViewController()
        
        detailsView.setRepository(repo: repository)
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

