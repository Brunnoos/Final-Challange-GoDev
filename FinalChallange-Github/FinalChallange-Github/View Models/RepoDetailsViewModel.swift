//
//  RepoDetailsViewModel.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 27/03/22.
//

import Foundation
import UIKit

class RepoDetailsViewModel {
    
    private var repository: Repository?
    private var repositoryURL: URL? = nil
    
    func setRepository(repo: Repository) {
        repository = repo
        
        if let url = URL(string: repo.htmlURL) {
            repositoryURL = url
        } else {
            repositoryURL = nil
        }
    }
    
    func getRepository() -> Repository? {
        return repository
    }
    
    func hasValidURL() -> Bool {
        return repositoryURL != nil
    }
    
    func openRepositoryLink() {
        if let url = repositoryURL, UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url)
        }
    }
    
    func getRepositoryCreatedAt() -> String? {
        if let repository = repository {
            
            let dateFiltered = repository.createdAt.filter { $0 != "Z"}
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "YYYY-MM-DDTHH:MM:SS"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"

            let date: NSDate? = dateFormatterGet.date(from: dateFiltered) as NSDate?
            
            let dateString = dateFormatterPrint.string(from: (date! as Date))
            
            return dateString
        }
        else {
            return nil
        }
    }
    
    func getRepositoryLicenseName() -> String? {
        if let repository = repository, let license = repository.license {
            return license.name
        }
        else {
            return nil
        }
    }
    
    func getRepositoryImagePath() -> URL? {
        if let repository = repository {
            let url = URL(string: repository.owner.avatarURL)
            
            return url
        }
        else {
            return nil
        }
    }
}
