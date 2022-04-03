//
//  HomeViewModel.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation
import Alamofire
import CoreData

class SearchViewModel {
    
    private var searchResponse: RepositorySearchResponse?
    private var searchPage = 1
    private var searchResponseCount = 0
    
    var delegate: SearchServiceDelegate?
    
    // MARK: - Public Methods
    
    func fetchSearch(searchParam: SearchParameters) {
        var search = searchParam
        searchPage = 1
        search.resultPage = searchPage
        
        SearchAPI.shared.searchLanguage(searchParams: search) { response in
            switch response {
            case .success(let result):
                self.onSucess(response: result, isAdditional: false)
            case .failure(let error):
                self.onFailure(error: error)
            }
        }
    }
    
    func fetchMoreSearch(searchParam: SearchParameters) {
        var search = searchParam
        search.resultPage = searchPage + 1
        
        SearchAPI.shared.searchLanguage(searchParams: search) { response in
            switch response {
            case .success(let result):
                self.onSucess(response: result, isAdditional: true)
            case .failure(let error):
                self.onFailure(error: error)
            }
        }
    }
    
    func getRepositories() -> [Repository]? {
        if let searchResponse = searchResponse {
            return searchResponse.repositories
        } else {
            return nil
        }
    }
    
    func hasLoadedAllRepositories() -> Bool {
        if let searchResponse = searchResponse {
            return searchResponse.totalCount == searchResponseCount
        } else {
            return false
        }
    }
    
    // MARK: - Private Methods
    
    /// This function modifies a SearchParameters to lower Minimum Stars parameter if necessary
    private func checkToLowerStars(searchParams: SearchParameters) -> SearchParameters {
        if hasLoadedAllRepositories() {
            return searchParams
        } else {
            return searchParams
        }
    }
    
    private func onSucess(response: RepositorySearchResponse, isAdditional: Bool) {
        self.searchResponse = response
        
        if isAdditional {
            searchPage += 1
            searchResponseCount += response.repositories.count
        } else {
            searchResponseCount = response.repositories.count
        }
        
        delegate?.onSearchCompleted(isAdditional: isAdditional)
    }
    
    private func onFailure(error: AFError) {
        delegate?.onSearchError(error: error.localizedDescription)
    }
    
    func getFavorityRepositories() throws -> [Repository]?  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GitRepo")
        let data =  try persistanceContainer.viewContext.fetch(request)
        var repositories: [Repository] = []
        for item in data as! [NSManagedObject] {
            let repository = Repository(
                id: item.value(forKey: "id") as! Int,
                nodeID: item.value(forKey: "nodeID") as! String,
                name: item.value(forKey: "name") as! String,
                fullName: item.value(forKey: "fullName") as! String,
                itemPrivate: item.value(forKey: "itemPrivate") as! Bool,
                owner: Owner(login: item.value(forKey: "ownerLogin") as! String,
                             id: item.value(forKey: "ownerId") as! Int,
                             nodeID: item.value(forKey: "ownerNodeID") as! String,
                             avatarURL: item.value(forKey: "ownerAvatarURL") as! String,
                             htmlURL: item.value(forKey: "ownerHtmlURL") as! String),
                htmlURL: item.value(forKey: "htmlURL") as! String,
                itemDescription: item.value(forKey: "itemDescription") as? String,
                createdAt: item.value(forKey: "createdAt") as! String,
                watchers: item.value(forKey: "watchers") as! Int,
                license: nil)
            
            repositories.insert(repository, at: 0)
        }
        return repositories
    }
}
