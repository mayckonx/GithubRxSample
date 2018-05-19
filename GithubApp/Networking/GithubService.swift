//
//  GithubService.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case cannotParse
}

/// A service that knows how to perform requests for GitHub data
class GithubService {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// - Returns: a list of languages from Github
    func getLanguageList() -> Observable<[String]> {
        
        // For simplicity we will use a stubbed list of languages
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "C#",
            ])
    }
    
    /// - Parameter language: Language to filter by
    /// - Returns: A list of most popular respositories filtered by language
    func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        return session.rx
            .json(url: url)
            .flatMap { json throws -> Observable<[Repository]> in
                guard
                    let json = json as? [String: Any],
                    let itemsJSON = json["items"] as? [[String: Any]]
                else { return Observable.error(ServiceError.cannotParse) }
                
                let repositories = itemsJSON.compactMap(Repository.init)
                return Observable.just(repositories)
        }
    }
    
}
