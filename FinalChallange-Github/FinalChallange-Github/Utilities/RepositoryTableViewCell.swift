//
//  RepositoryTableViewCell.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: - Lazy Properties
    
    lazy var repoImageView: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var repoDescriptionLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    lazy var repoFavoriteButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
}
