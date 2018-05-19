//
//  RepositoryCell.swift
//  GithubApp
//
//  Created by Mayckon Barbosa da Silva on 5/19/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var lblNameRepository: UILabel!
    @IBOutlet weak var lblLabelRepository: UILabel!
    @IBOutlet weak var lblCountStars: UILabel!
    
    func setName(_ name: String) {
        lblNameRepository.text = name
    }
    
    func setLabelDescription(_ label: String) {
        lblLabelRepository.text = label
    }
    
    func setStarsCountTest(_ starsCountText: String) {
        lblCountStars.text = starsCountText
    }
}
