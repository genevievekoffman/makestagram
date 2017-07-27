//
//  UserService.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/20/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct UserService {
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            let dispatchGroup = DispatchGroup()
            let posts: [Post] =
        snapshot
        .reversed()
            .flatMap {
                guard let post = Post(snapshot: $0)
                    else { return nil }
                dispatchGroup.enter()
                
                LikeService.isPostLiked(post) { (isLiked) in
                    post.isLiked = isLiked
                    
                    dispatchGroup.leave()
                }
                
                return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    } //checks if the post is liked by user. Use dispatch groups to wait for all of the asynchronous code to complete before calling our completion handler on the main thread. ???? 
    // Checks if a post returned is liked by the current user
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    } // use func to find a specific user and return it and all its info.
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    } // remove networking-related code (creating a new user)from createUsernameViewController. Place it inside struct. Acts as a link for communicating with our app and firebase.
}
