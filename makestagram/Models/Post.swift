//
//  Post.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/22/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    var isLiked = false // set to false because initially reading the posts data, the initial value in unknown
    var likeCount: Int
    let poster: User//properties 
    
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid,
                        "username" : poster.username]
        return ["image_url" : imageURL,     // why arent they recognizing the var from post.swift in models?
            "image_height" : imageHeight,
            "created_at" : createdAgo,
            "like_count" : likeCount,
            "poster" : userDict]
    }
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        
        self.likeCount = 0
        self.poster = User.current
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval,
            
            let likeCount = dict["like_count"] as? Int,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
    } // failable initializer
}
