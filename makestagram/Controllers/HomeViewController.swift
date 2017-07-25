//
//  HomeViewController.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/20/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController  {
    var posts = [Post]()  // creates empty array
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()  // fetches post from firebase
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    } // table view will display the same number of cells in our posts array
}
