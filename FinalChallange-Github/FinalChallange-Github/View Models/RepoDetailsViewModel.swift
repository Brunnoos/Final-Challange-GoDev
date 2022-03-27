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
    
    func setRepository(repo: Repository) {
        repository = repo
    }
    
    func getRepository() -> Repository? {
        return repository
    }
    
    func openRepositoryLink() {
        if let repository = repository {
            let url = URL(string: repository.htmlURL)
            
            if let url = url, UIApplication.shared.canOpenURL(url) {
                
                UIApplication.shared.open(url)
                
            }
        }
    }
    
    func getRepositoryCreatedAt() -> String? {
        if let repository = repository {
            let dateFormatter = DateFormatter()
            
            guard let date = dateFormatter.date(from: repository.createdAt) else { return nil }
            
            dateFormatter.dateFormat = "dd/MM/YYYY"
            let dateString = dateFormatter.string(from: date)
            
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
