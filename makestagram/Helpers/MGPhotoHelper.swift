//
//  MGPhotoHelper.swift
//  makestagram
//
//  Created by Genevieve Koffman on 7/21/17.
//  Copyright © 2017 Genevieve Koffman. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject { //when user has a image selected
    var completionHandler: ((UIImage) -> Void)?
    
    
     func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) { //checks if device has a camera
            
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            alertController.addAction(capturePhotoAction) // adds the action to alertController
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
                }) // performs previous steps for users photo library
            alertController.addAction(uploadAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction) // adds cancel action
        
        viewController.present(alertController, animated: true) //Dont understand line 
        
    } // this func initializes a new UIAlertController of type actionsheet(popup that will be displayed at bottom of screen) if the device has a camera available -> Creates a new UIAlertAction. Add the action to alertController instance(we just created) also does this for users library. cancel actions allows user to close UIAlertController.
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType // determines whether UIImagePickerController will activate to take photo or upload photo
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    } //creates new instance of UIImagePickerController, this object presents a native UI component (allows user to take photo or choose image) Presents view controller. -- we must implement the protocols because we are the delegate
}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true) // hides the image picker controller
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
// two delegation methods: one is called when image is selected, other is called when cancel is tapped
// didFinishPickingMediaWithInfo info: [String : Any] --> check if passed an image in dictionary, if there is an image it is passed to completionHandler 
