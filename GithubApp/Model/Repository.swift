//
//  Repository.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation

struct Repository {
    let fullName: String
    let description: String
    let starsCount: Int
    let url: String
}

extension Repository {
    init?(from json: [String: Any]) {
        guard
            let fullName = json["full_name"] as? String,
            let description = json["description"] as? String,
            let startsCount = json["stargazers_count"] as? Int,
            let url = json["html_url"] as? String
            else { return nil }
        
        self.init(fullName: fullName, description: description, starsCount: startsCount, url: url)
    }
}


extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.fullName == rhs.fullName
               && lhs.description == rhs.description
               && lhs.starsCount == rhs.starsCount
               && lhs.url == rhs.url
    }
}
