//
//  TeamViewController.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import UIKit

class TeamViewController: UIViewController {

    let tableView = TeamMembersTableView()
    
    override func loadView() {
        super.view = self.tableView
        delegates()
    }

    
    func delegates() {
        tableView.tableView.delegate = self
    }
}

extension TeamViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let teamMemberDetailView = TeamMemberDetailsViewController()
        let member = self.tableView.devs[indexPath.row]
        
        teamMemberDetailView.setTeamMember(person: member)
        navigationController?.pushViewController(teamMemberDetailView, animated: true)
    }
    
}
