//
//  Post.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/22/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import Foundation
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
}
