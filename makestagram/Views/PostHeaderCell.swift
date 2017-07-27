//
//  PostHeaderCell.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/26/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    static let height: CGFloat = 54  // adding cell height 
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
         print("options button tapped")
    }
}

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
