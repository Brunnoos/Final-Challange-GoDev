//
//  TeamMemberDescriptionVC.swift
//  FinalChallange-Github
//
//  Created by Idwall Go Dev 006 on 27/03/22.
//

import UIKit

class TeamMemberDescriptionVC: UIViewController {

    var person: Person?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
//    override func viewDidLoad() {
//        view.backgroundColor = .green
//    }
    
    let tableView = CellTableViewTableViewCell()
    
    override func loadView() {
        super.view = self.tableView
        delegates()
    }

    
    func delegates() {
        tableView.tableView.delegate = self
    }
}

extension TeamMemberDescriptionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    


}
