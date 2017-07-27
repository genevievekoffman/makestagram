//
//  PostActionCell.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/26/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}// allows the delegate to handle when the likeButton is tapped

class PostActionCell: UITableViewCell {
    weak var delegate: PostActionCellDelegate? // delegate property
    static let height: CGFloat = 46 // displays height of cell 
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self) // notifys the delegate when the likebutton is tapped
    } //sets HomeViewController as the delegate of PostActionCell
    
}
