//
//  AppCoordinator.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let repositoryListCoordinator = RepositoryListCoodinator(window: window)
        return coordinate(to: repositoryListCoordinator)
    }
}
