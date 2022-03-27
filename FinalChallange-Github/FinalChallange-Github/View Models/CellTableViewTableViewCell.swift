//
//  CellTableViewTableViewCell.swift
//
//
//

import UIKit

class CellTableViewTableViewCell: UIView {
        
    var devs = [Person(name: "Amaryllis Baldrez", description: "IOS Developer", image: "person2"), Person(name: "Bruno Oliveira", description: "IOS Developer", image: "bruno"), Person(name: "Rayanne Andrade", description: "Android/IOS Developer", image: "ray")]
    
    //MARK: - Components
    
            lazy var tableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(CustomTableView.self, forCellReuseIdentifier: CustomTableView.identifier)
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

extension CellTableViewTableViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devs.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableView.identifier, for: indexPath) as? CustomTableView else {return UITableViewCell()}
        let person = devs[indexPath.row]
        cell.setup(name: person.name, preview: person.description, image: person.image)
        return cell
    }
}

extension CellTableViewTableViewCell: ViewCodable {
    
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
