//
//  UIImage+Size.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/22/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
} //calculate the aspect height for the instance of UIImage based on its size properties ex: "adapts" to ipad sizes
