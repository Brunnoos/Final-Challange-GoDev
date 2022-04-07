//
//  MainTabBarController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Tab Bar Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupVCs()
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    // MARK: - Public Methods
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: SearchViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: FavoritesViewController(), title: NSLocalizedString("Favoritos", comment: ""), image: UIImage(systemName: "star")!),
            createNavController(for: TeamViewController(), title: NSLocalizedString("Time", comment: ""), image: UIImage(systemName: "person")!)
        ]
    }

}
