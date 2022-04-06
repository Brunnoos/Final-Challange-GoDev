//
//  MainTabBarController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: SearchViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: FavoritesViewController(), title: NSLocalizedString("Favoritos", comment: ""), image: UIImage(systemName: "star")!),
            createNavController(for: TeamViewController(), title: NSLocalizedString("Time", comment: ""), image: UIImage(systemName: "person")!)
        ]
    }

}
