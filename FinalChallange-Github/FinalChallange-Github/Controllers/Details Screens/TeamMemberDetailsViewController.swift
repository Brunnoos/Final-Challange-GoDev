//
//  TeamMemberDescriptionVC.swift
//  FinalChallange-Github
//
//  Created by Idwall Go Dev 006 on 27/03/22.
//

import Foundation
import UIKit
import MessageUI

class TeamMemberDetailsViewController: UIViewController {

    var person: Person?
    
    // MARK: - Private Properties
    
    private var safeArea: UILayoutGuide!
    
    // MARK: - Lazy Main Properties
    
    lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var personDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin iaculis vestibulum purus vitae rhoncus. Praesent placerat ac felis ultricies ornare. Curabitur egestas lacus nibh, sit amet vulputate urna finibus ac."
        return label
    }()
    
    lazy var personInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Lazy Repo Details Properties
    
    lazy var personPhoneNumber: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var personEmail: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var personLinkedin: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var personTwitter: InfoComponent = {
        let info = InfoComponent()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.isHidden = true
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
    
    // MARK: - Setup View Functions
    
    func setTeamMember(person: Person) {
        self.person = person
    }
    
    private func setupSafeArea() {
        safeArea = view.layoutMarginsGuide
    }
    
    private func setupViewContent() {
        guard let person = self.person else { return }
        
        title = person.name
        
        setupPersonImage(imageName: person.image)
        
        setupPersonDescription(description: person.description)
    }
    
    private func setupPersonImage(imageName: String) {
        personImageView.image = UIImage(named: imageName)
    }
    
    private func setupPersonDescription(description: String) {
        personDescriptionLabel.text = description
    }
    
    // MARK: - Private Setup Layout
    
    private func setupViewLayout() {
        setupPersonImageLayout()
        setupPersonDescriptionLayout()
        setupPersonInfoStackLayout()
        setupPersonInfoStackElementsLayout()
    }
    
    private func setupPersonImageLayout() {
        view.addSubview(personImageView)
        
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            personImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: 150),
            personImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupPersonDescriptionLayout() {
        view.addSubview(personDescriptionLabel)
        
        NSLayoutConstraint.activate([
            personDescriptionLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 23),
            personDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            personDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            personDescriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupPersonInfoStackLayout() {
        view.addSubview(personInfoStackView)
        
        NSLayoutConstraint.activate([
            personInfoStackView.topAnchor.constraint(equalTo: personDescriptionLabel.bottomAnchor, constant: 22),
            personInfoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            personInfoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupPersonInfoStackElementsLayout() {
        personInfoStackView.addArrangedSubview(personPhoneNumber)
        personInfoStackView.addArrangedSubview(personEmail)
        personInfoStackView.addArrangedSubview(personLinkedin)
        personInfoStackView.addArrangedSubview(personTwitter)
        
        NSLayoutConstraint.activate([
            personPhoneNumber.leadingAnchor.constraint(equalTo: personInfoStackView.leadingAnchor),
            personPhoneNumber.trailingAnchor.constraint(equalTo: personInfoStackView.trailingAnchor),
            personPhoneNumber.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            personEmail.leadingAnchor.constraint(equalTo: personInfoStackView.leadingAnchor),
            personEmail.trailingAnchor.constraint(equalTo: personInfoStackView.trailingAnchor),
            personEmail.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            personLinkedin.leadingAnchor.constraint(equalTo: personInfoStackView.leadingAnchor),
            personLinkedin.trailingAnchor.constraint(equalTo: personInfoStackView.trailingAnchor),
            personLinkedin.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            personTwitter.leadingAnchor.constraint(equalTo: personInfoStackView.leadingAnchor),
            personTwitter.trailingAnchor.constraint(equalTo: personInfoStackView.trailingAnchor),
            personTwitter.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }
    
    // MARK: - Private Setup Info Components
    
    private func setupComponents() {
        setupPhoneNumberComponent()
        setupEmailComponent()
        setupLinkedinComponent()
        setupTwitterComponent()
    }

    private func setupPhoneNumberComponent() {
        if let person = person {
            personPhoneNumber.isHidden = false
            personPhoneNumber.setupComponent(
                title: "Telefone",
                description: person.phoneNumber,
                icon: UIImage(systemName: "phone")!,
                descriptionLink: "tel://\(person.phoneNumber)")
            
            personPhoneNumber.infoTextView.addTarget(self, action: #selector(openPhoneNumber), for: .touchUpInside)
        } else {
            personPhoneNumber.isHidden = true
        }
        
    }
    
    private func setupEmailComponent() {
        if let person = person {
            personEmail.isHidden = false
            personEmail.setupComponent(
                title: "E-mail",
                description: person.email,
                icon: UIImage(systemName: "envelope")!,
                descriptionLink: "mailto:\(person.email)")
            
            personEmail.infoTextView.addTarget(self, action: #selector(openEmail), for: .touchUpInside)
        }
        else {
            personEmail.isHidden = true
        }
    }
    
    private func setupLinkedinComponent() {
        if let person = person {
            personLinkedin.isHidden = false
            personLinkedin.setupComponent(
                title: "Linkedin",
                description: person.linkedinURL,
                icon: UIImage(systemName: "network")!,
                descriptionLink: person.linkedinURL)
            
            personLinkedin.infoTextView.addTarget(self, action: #selector(openLinkedin), for: .touchUpInside)
        } else {
            personLinkedin.isHidden = true
        }
    }
    
    private func setupTwitterComponent() {
        if let person = person, let twitterURL = person.twitterURL {
            personTwitter.isHidden = false
            personTwitter.setupComponent(
                title: "Twitter",
                description: "@" + twitterURL,
                icon: UIImage(systemName: "network")!,
                descriptionLink: "twitter://user?screen_name=\(twitterURL)")
            
            personTwitter.infoTextView.addTarget(self, action: #selector(openTwitter), for: .touchUpInside)
        } else {
            personTwitter.isHidden = true
            
        }
    }
}

// MARK: - Open URL Actions

extension TeamMemberDetailsViewController: MFMailComposeViewControllerDelegate {
    
    @objc private func openPhoneNumber() {
        if let person = self.person {
            guard let url = URL(string: "tel://\(person.phoneNumber)") else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc private func openEmail() {
        if let person = self.person {
            let mailController = MFMailComposeViewController()
            
            mailController.setToRecipients([person.email])
            
            if MFMailComposeViewController.canSendMail() {
                present(mailController, animated: true)
            }
        }
    }
    
    @objc private func openLinkedin() {
        if let person = self.person {
            guard let url = URL(string: "https://linkedin.com/in/\(person.linkedinURL)") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openTwitter() {
        if let person = self.person, let twitterUser = person.twitterURL {
            guard let url = URL(string: "https://twitter.com/\(twitterUser)") else { return }
            UIApplication.shared.open(url)
        }
    }
    
}
