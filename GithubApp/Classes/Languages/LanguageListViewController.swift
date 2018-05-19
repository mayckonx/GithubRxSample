//
//  LanguageListViewController.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageListViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: LanguageListViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"
        
        tableView.rowHeight = 48.0
    }
    
    private func setupBindings() {
        
        viewModel.outputLanguages
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { (_, language, cell) in
                cell.textLabel?.text = language
                cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
        .bind(to: viewModel.inputSelectLanguage)
        .disposed(by: disposeBag)
        
        cancelButton.rx.tap
        .bind(to: viewModel.inputCancel)
        .disposed(by: disposeBag)
        
    }

}
