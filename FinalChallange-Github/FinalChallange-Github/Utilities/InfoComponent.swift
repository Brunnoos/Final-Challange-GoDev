//
//  InfoComponent.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 27/03/22.
//

import UIKit

class InfoComponent: UIView {
    
    // MARK: - Private Properties
    
    private var infoText: NSMutableAttributedString?
    
    // MARK: - Lazy Properties
    
    lazy var infoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var infoTextView: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        label.dataDetectorTypes = UIDataDetectorTypes.link
        label.attributedText = NSMutableAttributedString(string: "Teste de Label")
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Setup Component Functions
    
    func setupComponent(title: String, description: String, icon: UIImage, descriptionLink: String?) {
        
        setupInfoLayout()
        
        setupInfoImage(image: icon)
        setupInfoText(title: title, description: description, link: descriptionLink)
        
    }
    
    // MARK: - Setup Text Functions
    
    private func setupInfoText(title: String, description: String, link: String?) {
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let descriptionAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        infoText = NSMutableAttributedString(string: title + ": " + description)
        
        if let infoText = infoText {
            let foundTitle = infoText.mutableString.range(of: title + ":")
            let foundDescription = infoText.mutableString.range(of: description)
            
            if foundTitle.location != NSNotFound {
                infoText.addAttributes(titleAttributes, range: foundTitle)
            }
            
            if foundDescription.location != NSNotFound {
                infoText.addAttributes(descriptionAttributes, range: foundDescription)
                
                if let link = link {
                    infoText.addAttribute(.link, value: link, range: foundDescription)
                }
            }
            
            infoTextView.attributedText = infoText
        }
    }
    
    // MARK: - Setup Image Functions
    
    private func setupInfoImage(image: UIImage) {
        infoImageView.image = image
    }
    
    // MARK: - Setup Layout Functions
    
    private func setupInfoLayout() {
        
        addSubview(infoImageView)
        setupImageLayout()
        
        addSubview(infoTextView)
        setupTextLayout()
    }
    
    private func setupImageLayout() {
        NSLayoutConstraint.activate([
            infoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 36),
            infoImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupTextLayout() {
        NSLayoutConstraint.activate([
            infoTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 4),
            infoTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
