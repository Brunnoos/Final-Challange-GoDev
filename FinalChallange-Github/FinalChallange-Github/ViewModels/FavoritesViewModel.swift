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
