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
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        return ["image_url" : imageURL,     // why arent they recognizing the var from post.swift in models?
            "image_height" : imageHeight,
            "created_at" : createdAgo]
    }
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval
            else { return nil }
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
    } // failable initializer 
}
