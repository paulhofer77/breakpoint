//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Paul Hofer on 02.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupMemeberLabel: UILabel!
    
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLabel.text = title
        self.groupDescriptionLabel.text = description
        self.groupMemeberLabel.text = "\(memberCount) Members"
    }
    
  

}
