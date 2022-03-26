//
//  APIService.swift
//  FinalChallange-Github
//
//  Created by Aloc FL00030 on 26/03/22.
//

import Foundation
import Alamofire

enum SearchOrder: String {
    case ascendent = "asc"
    case descendent = "desc"
}

struct SearchParameters {
    var language: String
    var order = SearchOrder.descendent
    var minStars: Int = 10000
    var resultsPerPage: Int? = nil
    var resultPage: Int? = nil
}

class SearchAPI {
    
    // MARK: - Singleton Setup
    
    static let shared: SearchAPI = {
        let instance = SearchAPI()
        return instance
    }()
    
    // MARK: - Private Properties
    
    private let apiURL = "https://api.github.com/search/repositories"
    
    // MARK: - Search Functions
    
    func searchLanguage(searchParams: SearchParameters) -> RepositorySearchResponse? {
        
        var result: RepositorySearchResponse?
        var queryString = "?q=stars:%3E=\(searchParams.minStars)+language:\(searchParams.language)"
        
        queryString += "&sort=stars"
        queryString += "&order=" + searchParams.order.rawValue
        
        if let resultsPerPage = searchParams.resultsPerPage {
            queryString += "&per_page=\(resultsPerPage)"
        }
        
        if let resultPage = searchParams.resultPage {
            queryString += "&page=\(resultPage)"
        }
        
        AF.request(apiURL + queryString).responseDecodable(of: RepositorySearchResponse.self) { response in
            print (response.value ?? "Vazio")
            result = response.value
        }
        
        return result
    }
}
