//
//  LanguageListViewModel.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxSwift

class LanguageListViewModel {
    
    // MARK: - Inputs
    
    let inputSelectLanguage: AnyObserver<String>
    let inputCancel: AnyObserver<Void>
    
    // MARK: - Outputs
    let outputLanguages: Observable<[String]>
    let outputDidSelectLanguage: Observable<String>
    let outputDidCancel: Observable<Void>
    
    init(githubService: GithubService = GithubService()) {
        self.outputLanguages = githubService.getLanguageList()
        
        let _inputSelectLanguage = PublishSubject<String>()
        self.inputSelectLanguage = _inputSelectLanguage.asObserver()
        self.outputDidSelectLanguage = _inputSelectLanguage.asObservable()
        
        let _inputCancel = PublishSubject<Void>()
        self.inputCancel = _inputCancel.asObserver()
        self.outputDidCancel = _inputCancel.asObservable()
    }
    
    
}
