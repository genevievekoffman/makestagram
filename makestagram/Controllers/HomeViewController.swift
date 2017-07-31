//
//  HomeViewController.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/20/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import Kingfisher  // displays UIimages - already coded for us
import UIKit


class HomeViewController: UIViewController  {
    var posts = [Post]()  // creates empty array
   

    
    @IBOutlet weak var tableView: UITableView!
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }() // creates a new dateFormatter- converts a date to string
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()  // fetches post from firebase
        }
    }
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    } // adds styling for table view
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // returns 3 rows for each section - header, image, action cells
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section] 
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self //makes itself the delegate 
            configureCell(cell, with: post)

            return cell
            
        default:
            fatalError("Error: unexpected indexPath.") // do i need this
        }
    } // returns the corresponding cell, table view will display the same number of cells in our posts array
    // if the image is liked, we set the isSelected of the UIbutton to true  
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return PostHeaderCell.height
            case 1:
                let post = posts[indexPath.section]
                return post.imageHeight
        // returns the height that each cell should be given an index path ? - allows there to be multiple cells with varying heights in the same tableview
            case 2:
                return PostActionCell.height
            default:
                fatalError()
            }
        }
    }

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        
        guard let indexPath = tableView.indexPath(for: cell)
            else { return } // make sure index path exists for cell
        
        likeButton.isUserInteractionEnabled = false //Sets isUserInteractionEnabled property of UIButton to false- so user doesn't send multiple requests
    
        let post = posts[indexPath.section] // Reference the correct post corresponding with the PostActionCell the user tapped
        
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in // uses func to like or unlike
            
            defer {
                likeButton.isUserInteractionEnabled = true
            } //sets isUserInteractionEnabled to true when the closure returns
            
            guard success else { return } // handles error
            
            
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked // changes the like count & is liked properties (if network request is succesful)
            
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return } // gets refernce to current cell
            
            DispatchQueue.main.async {
                self.configureCell(cell, with: post) // update UI of the cell
            }
        }
    }
}

// groups the tableview into sections - every post is its own section with 3 rows
