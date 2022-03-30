//
//  CellTableViewTableViewCell.swift
//
//
//

import UIKit

class TeamMembersTableView: UIView {
        
    var devs: [Person] = [
        .init(name: "Amaryllis Baldrez", ocupation: "iOS Developer", image: "person2", description: "Sem descrição", phoneNumber: "(99) 999999999", email: "email@email.com", linkedinURL: "https://linkedin.com"),
        .init(name: "Bruno Oliveira", ocupation: "iOS Developer", image: "bruno", description: "Sem descrição", phoneNumber: "(99) 999999999", email: "brunno.os159@gmail.com", linkedinURL: "https://linkedin.com"),
        .init(name: "Rayanne Andrade", ocupation: "Android/IOS Developer", image: "ray", description: "Sem descrição", phoneNumber: "(99) 999999999", email: "email@email.com", linkedinURL: "https://linkedin.com")
    ]
    
    //MARK: - Components
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TeamMemberTableViewCell.self, forCellReuseIdentifier: TeamMemberTableViewCell.identifier)
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    //MARK: - Protocols

extension TeamMembersTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamMemberTableViewCell.identifier, for: indexPath) as? TeamMemberTableViewCell else {return UITableViewCell()}
        let person = devs[indexPath.row]
        cell.setup(name: person.name, preview: person.ocupation, image: person.image)
        return cell
    }
}

extension TeamMembersTableView: ViewCodable {
    
    func buildHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
