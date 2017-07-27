//
//  LikeService.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/27/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct LikeService {
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else { //make sure it has a key
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("postLikes").child(postKey)// build relative path to location where like data is stored
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false) //use query that that checks whether a value exists at the location. If it does exist- user has liked the picture, otherwise they didn't
            } // func determines wether a post is liked by the user
        })
    }
    static func create(for post: Post, success: @escaping (Bool) -> Void) {
        guard let key = post.key else { // every post liked must have a key. Check if it has a key and return false if it doesnt.
            return success(false)
        }
        let currentUID = User.current.uid // create reference to the users UID (used for the location of stored date)
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID) // define location for data , likesRef is like button?
        
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)}
                else {
                    success(true)
                }
                // network success was successfully executed - data was saved to the database
                // increments the like_count of a post after a post has been liked
                // uses the poster property to build the path to the like count location
            })
        }
    }
        static func delete(for post: Post, success: @escaping (Bool) -> Void) {
            guard let key = post.key else {
                return success(false)
            }
            let currentUID = User.current.uid
            let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
            
            likesRef.setValue(nil) { (error, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                }
                let likeCountRef =
                Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
                likeCountRef.runTransactionBlock({ (MutableData) -> TransactionResult in
                    let currentCount = MutableData.value as? Int ?? 0
                    
                    MutableData.value = currentCount - 1
                    
                    return TransactionResult.success(withValue: MutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        success(false) }
                    else {
                        success(true)
                    }
                })
            } // func sets like button to nil (unlike) - deleting the node at that location
        }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            create(for: post, success: success)
        } else {
            delete(for: post, success: success)
        }
    } // convienence method to easily like or unlike posts 
    // when likeButton of the PostActionCell is tapped
}
