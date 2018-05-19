//
//  LanguageListCoordinator.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift

/// Type that defines possible coordination results of `LanguageListCoordinator`
///
/// - language: Language was choosen.
/// - cancel: Cancel button was tapped.

enum LanguageListCoordinationResult {
    case language(String)
    case cancel
}

class LanguageListCoordinator: BaseCoordinator<LanguageListCoordinationResult> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<LanguageListCoordinationResult> {
        let viewController = LanguageListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = LanguageListViewModel()
        viewController.viewModel = viewModel
        
        let cancel = viewModel.outputDidCancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.outputDidSelectLanguage.map { CoordinationResult.language($0) }
        
        rootViewController.present(navigationController, animated: true)
        
        return Observable.merge(cancel, language)
                .take(1)
                .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
    
}
