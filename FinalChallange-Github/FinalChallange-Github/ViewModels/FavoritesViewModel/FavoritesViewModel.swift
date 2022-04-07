//
//  FavoritesViewModel.swift
//  FinalChallange-Github
//
//  Created by Idwall Go Dev 006 on 02/04/22.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewModel {
    
    func getRepositories() throws -> [Repository]?  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GitRepo")
        let data =  try persistanceContainer.viewContext.fetch(request)
        var repositories: [Repository] = []
        for item in data as! [NSManagedObject] {
            let repository = convertNSObjectToRepository(object: item)
            
            if let repository = repository {
                repositories.insert(repository, at: 0)
            }
        }
        return repositories
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
