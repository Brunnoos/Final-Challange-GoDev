//
//  LoadMoreTableViewCell.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 02/04/22.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static let identifier = "LoadMoreTableViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        indicator.style = .large
        indicator.color = .black
        return indicator
    }()
    
    // MARK: - Public Methods
    
    func initialSetup() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        setupLayouts()
    }
    
    func startLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - Layout Setup Methods
    
    private func setupLayouts() {
        setupLoadingIndicatorLayout()
    }
    
    private func setupLoadingIndicatorLayout() {
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

}
