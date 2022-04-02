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
    var minStars: Int = 100
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
    
    func searchLanguage(searchParams: SearchParameters, onCompletion: @escaping (Result<RepositorySearchResponse, AFError>) -> Void) {
        
        let language = searchParams.language.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let language = language {
            var queryString = "?q=+language:\(language)"
            
            queryString += "&sort=stars"
            queryString += "&order=" + searchParams.order.rawValue
            
            if let resultsPerPage = searchParams.resultsPerPage {
                queryString += "&per_page=\(resultsPerPage)"
            }
            
            if let resultPage = searchParams.resultPage {
                queryString += "&page=\(resultPage)"
            }
            
            AF.request(apiURL + queryString).responseDecodable(of: RepositorySearchResponse.self) { response in                
                onCompletion(response.result)
            }
        }
        else {
            onCompletion(.failure(AFError.explicitlyCancelled))
        }
    }
}
