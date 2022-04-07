//
//  SearchServiceDelegate.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation

protocol SearchServiceDelegate {
    func onSearchCompleted(isAdditional: Bool)
    
    func onSearchError(error: String)
}
