//
//  RepoDetailsViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 27/03/22.
//

import UIKit
import Kingfisher

class RepoDetailsViewController: UIViewController {

    // MARK: - Private Properties
    
    private var safeArea: UILayoutGuide!
    private let viewModel = RepoDetailsViewModel()
    
    private var repositoryURL: URL?
    
    // MARK: - Lazy Main Properties
    
    lazy var repoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin iaculis vestibulum purus vitae rhoncus. Praesent placerat ac felis ultricies ornare. Curabitur egestas lacus nibh, sit amet vulputate urna finibus ac."
        return label
    }()
    
    lazy var repoInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    lazy var repoLinkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        button.layer.cornerRadius = 6
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Abrir Repositório", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(onRepoLinkButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lazy Repo Details Properties
    
    lazy var repoAuthorName: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var repoWatchersCount: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var repoCreatedAt: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var repoLicense: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    // MARK: UIViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSafeArea()
        setupViewLayout()
        setupComponents()
        
        setupViewContent()
    }
    
    @objc private func openRepositoryLink() {
        
    }
    
    // MARK: - Setup View Functions
    
    func setRepository(repo: Repository) {
        viewModel.setRepository(repo: repo)
    }
    
    private func setupSafeArea() {
        safeArea = view.layoutMarginsGuide
    }
    
    private func setupViewContent() {
        guard let repo = viewModel.getRepository() else { return }
        
        title = repo.name
        
        if let imageURL = viewModel.getRepositoryImagePath() {
            setupRepoImage(imageURL: imageURL)
        }
        
        if let description = repo.itemDescription {
            repoDescriptionLabel.isHidden = false
            setupRepoDescription(description: description)
        } else {
            repoDescriptionLabel.isHidden = true
        }
    }
    
    private func setupRepoImage(imageURL: URL) {
        repoImageView.kf.setImage(with: imageURL)
    }
    
    private func setupRepoDescription(description: String) {
        repoDescriptionLabel.text = description
    }
    
    @objc func onRepoLinkButtonPressed() {
        viewModel.openRepositoryLink()
    }
    
    // MARK: - Private Setup Layout
    
    private func setupViewLayout() {
        setupRepoImageLayout()
        setupRepoDescriptionLayout()
        setupRepoInfoStackLayout()
        setupRepoInfoStackElementsLayout()
        setupRepoLinkButtonLayout()
    }
    
    private func setupRepoImageLayout() {
        view.addSubview(repoImageView)
        
        NSLayoutConstraint.activate([
            repoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            repoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            repoImageView.widthAnchor.constraint(equalToConstant: 200),
            repoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupRepoDescriptionLayout() {
        view.addSubview(repoDescriptionLabel)
        
        NSLayoutConstraint.activate([
            repoDescriptionLabel.topAnchor.constraint(equalTo: repoImageView.bottomAnchor, constant: 23),
            repoDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            repoDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            repoDescriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupRepoInfoStackLayout() {
        view.addSubview(repoInfoStackView)
        
        NSLayoutConstraint.activate([
            repoInfoStackView.topAnchor.constraint(equalTo: repoDescriptionLabel.bottomAnchor, constant: 22),
            repoInfoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            repoInfoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupRepoInfoStackElementsLayout() {
        repoInfoStackView.addArrangedSubview(repoAuthorName)
        repoInfoStackView.addArrangedSubview(repoWatchersCount)
        repoInfoStackView.addArrangedSubview(repoCreatedAt)
        repoInfoStackView.addArrangedSubview(repoLicense)
        
        NSLayoutConstraint.activate([
            repoAuthorName.leadingAnchor.constraint(equalTo: repoInfoStackView.leadingAnchor),
            repoAuthorName.trailingAnchor.constraint(equalTo: repoInfoStackView.trailingAnchor),
            repoAuthorName.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            repoWatchersCount.leadingAnchor.constraint(equalTo: repoInfoStackView.leadingAnchor),
            repoWatchersCount.trailingAnchor.constraint(equalTo: repoInfoStackView.trailingAnchor),
            repoWatchersCount.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            repoCreatedAt.leadingAnchor.constraint(equalTo: repoInfoStackView.leadingAnchor),
            repoCreatedAt.trailingAnchor.constraint(equalTo: repoInfoStackView.trailingAnchor),
            repoCreatedAt.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            repoLicense.leadingAnchor.constraint(equalTo: repoInfoStackView.leadingAnchor),
            repoLicense.trailingAnchor.constraint(equalTo: repoInfoStackView.trailingAnchor),
            repoLicense.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }
    
    private func setupRepoLinkButtonLayout() {
        view.addSubview(repoLinkButton)
        
        NSLayoutConstraint.activate([
            repoLinkButton.topAnchor.constraint(equalTo: repoInfoStackView.bottomAnchor, constant: 16),
            repoLinkButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            repoLinkButton.heightAnchor.constraint(equalToConstant: 30),
            repoLinkButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // MARK: - Private Setup Info Components
    
    private func setupComponents() {
        setupAuthorNameComponent()
        setupWatchersCountComponent()
        setupCreatedAtComponent()
        setupLicenseComponent()
    }

    private func setupAuthorNameComponent() {
        repoAuthorName.setupComponent(
            title: "Autor",
            description: (viewModel.getRepository()?.owner.login ?? "Vazio"),
            icon: UIImage(systemName: "person.circle")!,
            descriptionLink: nil)
    }
    
    private func setupWatchersCountComponent() {
        repoWatchersCount.setupComponent(
            title: "Contagem de Observadores",
            description: String(viewModel.getRepository()?.watchers ?? 0),
            icon: UIImage(systemName: "eye")!,
            descriptionLink: nil)
    }
    
    private func setupCreatedAtComponent() {
        repoCreatedAt.setupComponent(
            title: "Data de Criação",
            description: (viewModel.getRepositoryCreatedAt() ?? "00/00/0000"),
            icon: UIImage(systemName: "deskclock")!,
            descriptionLink: nil)
    }
    
    private func setupLicenseComponent() {
        repoLicense.setupComponent(
            title: "Licença",
            description: (viewModel.getRepositoryLicenseName() ?? "Vazio"),
            icon: UIImage(systemName: "network")!,
            descriptionLink: nil)
    }
}
