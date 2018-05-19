//
//  RepositoryListCoordinator.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoodinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
       self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = RepositoryListViewModel(initialLanguage: "Swift")
        let viewController = RepositoryListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.outputShowRepository
            .subscribe(onNext: { [weak self] in self?.showRepository(by: $0, in: navigationController) })
            .disposed(by: disposeBag)
        
        viewModel.outputShowLanguageList
            .flatMap{ [weak self] _ -> Observable<String?> in
                guard let `self` = self else { return .empty() }
                return self.showLanguageList(on: viewController)
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.inputSetCurrentLanguage)
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
        
    }
    
    private func showRepository(by url: URL, in navigationController: UINavigationController) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariViewController, animated: true)
    }
    
    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
       let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
       return coordinate(to: languageListCoordinator)
        .map { result in
            switch result {
            case .language(let language) : return language
            case .cancel: return nil
            }
        }
    }
}
