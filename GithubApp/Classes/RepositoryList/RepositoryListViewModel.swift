//
//  RepositoryListViewModel.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {
    
    // MARK - Inputs
    
    /// Call to update current language. Causes reload of the repositories
    let inputSetCurrentLanguage: AnyObserver<String>
    
    /// Call to show language list screen
    let inputChooseLanguage: AnyObserver<Void>
    
    /// Call to open repository page
    let inputSelectRepository: AnyObserver<RepositoryViewModel>
    
    /// Call to reload repositories
    let inputReload: AnyObserver<Void>
    
    
    // MARK: - Outputs
    
    /// Emits an array of fetched repositories
    let outputRepositories: Observable<[RepositoryViewModel]>
    
    /// Emits a formatted title for a navigation item
    let outputTitle: Observable<String>
    
    /// Emits an error messages to be shown.
    let outputAlertMessage: Observable<String>
    
    /// Emits an url of repository page to be shown.
    let outputShowRepository: Observable<URL>
    
    /// Emits when we should show language list.
    let outputShowLanguageList: Observable<Void>
    
    init(initialLanguage: String, githubService: GithubService = GithubService()) {
        
        let _inputReload = PublishSubject<Void>()
        self.inputReload = _inputReload.asObserver()
        
        let _inputCurrentLanguage = BehaviorSubject<String>(value: initialLanguage)
        self.inputSetCurrentLanguage = _inputCurrentLanguage.asObserver()
        
        self.outputTitle = _inputCurrentLanguage.asObservable()
            .map{"\($0) "}
        
        let _outputAlertMessage = PublishSubject<String>()
        self.outputAlertMessage = _outputAlertMessage.asObservable()
        
        self.outputRepositories = Observable.combineLatest(_inputReload, _inputCurrentLanguage) {_, language in language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                .catchError { error in
                    _outputAlertMessage.onNext(error.localizedDescription)
                    return Observable.empty()
                }
        }
        .map{ repositories in repositories.map(RepositoryViewModel.init) }
        
        let _inputSelectRepository = PublishSubject<RepositoryViewModel>()
        self.inputSelectRepository = _inputSelectRepository.asObserver()
        self.outputShowRepository = _inputSelectRepository.asObservable()
            .map{ $0.url }
        
        let _inputChooseLanguage = PublishSubject<Void>()
        self.inputChooseLanguage = _inputChooseLanguage.asObserver()
        self.outputShowLanguageList = _inputChooseLanguage.asObservable()        

    }
}
