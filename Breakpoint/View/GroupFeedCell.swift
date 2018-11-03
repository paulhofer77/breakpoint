//
//  GroupFeedCell.swift
//  Breakpoint
//
//  Created by Paul Hofer on 03.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

  
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    

    func configureCell(profileImage: UIImage, email: String, content: String) {
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = content
    }
    
    
}
