//
//  RepositoryTableViewCell.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "RepositoryTableViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var repoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 85 / 2
        return image
    }()
    
    lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    lazy var repoFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Cell Setup
    
    func setupCell(repository: Repository, isFavorite: Bool) {
        setupLayouts()
        
        setupRepoName(name: repository.name)
        setupRepoImage(imageURL: repository.owner.avatarURL)
        setupRepoDescription(description: repository.itemDescription)
        setupFavoriteButton(isFavorite: isFavorite)
    }
    
    private func setupRepoName(name: String) {
        repoNameLabel.text = name
    }
    
    private func setupRepoImage(imageURL: String) {
        
        if let url = URL(string: imageURL) {
            repoImageView.kf.setImage(with: url)
        }
    }
    
    private func setupRepoDescription(description: String?) {
        if let description = description {
            repoDescriptionLabel.isHidden = false
            repoDescriptionLabel.text = description
        } else {
            repoDescriptionLabel.isHidden = true
        }
    }
    
    private func setupFavoriteButton(isFavorite: Bool) {
        if isFavorite {
            repoFavoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            repoFavoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    // MARK: - Layout Setup
    
    private func setupLayouts() {
        setupImageLayout()
        setupFavoriteButtonLayout()
        setupNameLayout()
        setupDescriptionLayout()
    }
    
    private func setupImageLayout() {
        addSubview(repoImageView)
        
        NSLayoutConstraint.activate([
            repoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            repoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            repoImageView.heightAnchor.constraint(equalToConstant: 85),
            repoImageView.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    private func setupNameLayout() {
        addSubview(repoNameLabel)
        
        NSLayoutConstraint.activate([
            repoNameLabel.topAnchor.constraint(equalTo: repoImageView.topAnchor),
            repoNameLabel.leadingAnchor.constraint(equalTo: repoImageView.trailingAnchor, constant:  13),
            repoNameLabel.trailingAnchor.constraint(equalTo: repoFavoriteButton.leadingAnchor, constant: -4),
            repoNameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupDescriptionLayout() {
        addSubview(repoDescriptionLabel)
        
        NSLayoutConstraint.activate([
            repoDescriptionLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: 4),
            repoDescriptionLabel.leadingAnchor.constraint(equalTo: repoNameLabel.leadingAnchor),
            repoDescriptionLabel.trailingAnchor.constraint(equalTo: repoNameLabel.trailingAnchor)
        ])
    }
    
    private func setupFavoriteButtonLayout() {
        addSubview(repoFavoriteButton)
        
        NSLayoutConstraint.activate([
            repoFavoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            repoFavoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repoFavoriteButton.heightAnchor.constraint(equalToConstant: 36),
            repoFavoriteButton.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
}
