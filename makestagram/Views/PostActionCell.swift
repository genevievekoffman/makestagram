//
//  PostActionCell.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/26/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {
    static let height: CGFloat = 46 // displays height of cell 
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        print("like button tapped")
    }
    
}
