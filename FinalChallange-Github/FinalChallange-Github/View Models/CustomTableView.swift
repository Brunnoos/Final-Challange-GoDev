//
//  CustomTableView.swift
//  FinalChallange-Github
//
//  Created by Idwall Go Dev 006 on 27/03/22.
//

import UIKit

protocol action {
    
}

class CustomTableView: UITableViewCell {
    
    //MARK: - Components
    
    static let identifier = "CustomTableView"
    
    private lazy var verticalStack: UIStackView = {
        let stack  = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.contentMode = .top
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
        
    private lazy var personName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private lazy var personDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = UIColor.black
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return description
    }()
    
    private lazy var personImage: UIImageView = {
        let personImage = UIImageView()
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.contentMode = .scaleAspectFill
        return personImage
    }()
    
    func setup(name: String, preview: String, image: String) {
        personName.text = name
        personDescription.text = preview
        personImage.image = UIImage(named: image)
        personImage.layer.masksToBounds = true
        personImage.layer.cornerRadius = 30
    }
    
    
    //MARK: - Inicialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTableView: ViewCodable {
    
    func buildHierarchy() {
        addSubview(personImage)
        
        verticalStack.addArrangedSubview(personName)
        verticalStack.addArrangedSubview(personDescription)
        
        addSubview(verticalStack)
        
    }
    
    func setupConstraints() {
        
        personImage.layer.cornerRadius = personImage.layer.frame.width / 2
        
        NSLayoutConstraint.activate([
            personImage.heightAnchor.constraint(equalToConstant: 60),
            personImage.widthAnchor.constraint(equalToConstant: 60),
            personImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            personImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
            verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            verticalStack.leadingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: 10),
            verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            verticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35)
        ])
    }
}

