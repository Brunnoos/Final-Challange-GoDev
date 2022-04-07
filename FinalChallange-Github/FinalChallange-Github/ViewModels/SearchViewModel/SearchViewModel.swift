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
    
    // MARK: - Private Properties
    
    private var searchResponse: RepositorySearchResponse?
    private var searchPage = 1
    private var searchResponseCount = 0
    
    // MARK: - Public Properties
    
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
    
    func getFavorityRepositories() -> [Repository]?  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GitRepo")
        var repositories: [Repository] = []
        do {
            let data =  try persistanceContainer.viewContext.fetch(request)
            for item in data as! [NSManagedObject] {
                let repository = convertNSObjectToRepository(object: item)
                
                if let repository = repository {
                    repositories.insert(repository, at: 0)
                }
            }
            
            return repositories
        } catch {
            print(error)
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
    
    private func convertNSObjectToRepository(object: NSManagedObject) -> Repository? {
        
        /// Repository Info
        guard let id = object.value(forKey: "id") as? Int else { return nil }
        guard let nodeID = object.value(forKey: "nodeID") as? String else { return nil }
        guard let name = object.value(forKey: "name") as? String else { return nil }
        guard let fullName = object.value(forKey: "fullName") as? String else { return nil }
        guard let itemPrivate = object.value(forKey: "itemPrivate") as? Bool else { return nil }
        guard let htmlURL = object.value(forKey: "htmlURL") as? String else { return nil }
        guard let itemDescription = object.value(forKey: "itemDescription") as? String else { return nil }
        guard let createdAt = object.value(forKey: "createdAt") as? String else { return nil }
        guard let watchers = object.value(forKey: "watchers") as? Int else { return nil }
        
        
        /// Owner Info
        guard let ownerLogin = object.value(forKey: "ownerLogin") as? String else { return nil}
        guard let ownerID = object.value(forKey: "ownerId") as? Int else { return nil }
        guard let ownerNodeID = object.value(forKey: "ownerNodeID") as? String else { return nil }
        guard let ownerAvatarURL = object.value(forKey: "ownerAvatarURL") as? String else { return nil }
        guard let ownerHtmlURL = object.value(forKey: "ownerHtmlURL") as? String else { return nil }
        
        let owner = Owner(login: ownerLogin,
                          id: ownerID,
                          nodeID: ownerNodeID,
                          avatarURL: ownerAvatarURL,
                          htmlURL: ownerHtmlURL)
        
        let repository = Repository(id: id,
                                    nodeID: nodeID,
                                    name: name,
                                    fullName: fullName,
                                    itemPrivate: itemPrivate,
                                    owner: owner,
                                    htmlURL: htmlURL,
                                    itemDescription: itemDescription,
                                    createdAt: createdAt,
                                    watchers: watchers,
                                    license: nil)
        
        return repository
    }
}
