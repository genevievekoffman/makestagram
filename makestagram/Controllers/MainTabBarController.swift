//
//  MainTabBarController.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/21/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    let photoHelper = MGPhotoHelper()  // creates instance MGPhotoHelper object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)  //sets a closure. Whenever MGPhotoHelper recieves an image, calls this closure
        }
        
        delegate = self
        
        tabBar.unselectedItemTintColor = .black
    } // sets the MainTabBarController as the delegate of its tab bar, set its color to black 0.0
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self) //presents the action sheet from photoHelper, allows user to take a photo or upload a photo
            return false
        } else {
            return true    } // returns bool value that determines if the tab bar should present the selected UI view controller. if false, view controller will not be displayed.
    }
}
