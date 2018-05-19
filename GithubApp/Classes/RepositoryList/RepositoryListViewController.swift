//
//  ViewController.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class RepositoryListViewController: UIViewController, StoryboardInitializable {

    private enum SegueType: String {
        case languageList = "Show Language List"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                                       target: nil,
                                                       action: nil)
    private let refreshControl = UIRefreshControl()
    
    var viewModel = RepositoryListViewModel(initialLanguage: "Swift")
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func setupBindings() {
        
        // View Model outputs to the ViewController
        
        viewModel.outputRepositories
        .observeOn(MainScheduler.instance)
            .do(onNext: {[weak self] _ in self?.refreshControl.endRefreshing()})
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) {
                [weak self] (_, repo, cell) in
                self?.setupRepositoryCell(cell, repository: repo)
        }
        .disposed(by: disposeBag)
        
        viewModel.outputTitle
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)
        

        viewModel.outputAlertMessage
            .subscribe(onNext: { [weak self] in self?.presentAlert(message: $0) })
            .disposed(by: disposeBag)
        
        // View Controller UI actions to the view Model
        refreshControl.rx.controlEvent(.valueChanged)
        .bind(to: viewModel.inputReload)
        .disposed(by: disposeBag)
        
        chooseLanguageButton.rx.tap
        .bind(to: viewModel.inputChooseLanguage)
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RepositoryViewModel.self)
        .bind(to: viewModel.inputSelectRepository)
        .disposed(by: disposeBag)
        
    }
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
        cell.selectionStyle = .none
        cell.setName(repository.name)
        cell.setLabelDescription(repository.description)
        cell.setStarsCountTest(repository.starsCountText)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}



