//
//  GBHFacebookImagePickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public protocol GBHFacebookImagePickerDelegate: class {

    /// Called when image is picked
    ///
    /// - Parameters:
    ///   - imagePicker: the picker controller
    ///   - imageModel: GBHFacebookImageModel which containt image url, image and image id
    func facebookImagePicker(imagePicker: UIViewController,
                             imageModel: GBHFacebookImage)

    /// Called when facebook picker failed
    ///
    /// - Parameters:
    ///   - imagePicker: the picker controller
    ///   - error: with description
    func facebookImagePicker(imagePicker: UIViewController,
                             didFailWithError error: Error?)

    /// Called when facebook picker is cancelled without error
    ///
    /// - Parameter imagePicker: the picker controller
    func facebookImagePicker(didCancelled imagePicker: UIViewController)

    /// Called when image picker completed dismissing
    func facebookImagePickerDismissed()
}

// Extension to make some method optional...
public extension GBHFacebookImagePickerDelegate {
    func facebookImagePickerDismissed() {
        // Override in your controller to make your own implementation ! 
    }

    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        // Override in your controller to make your own implementation ! 
    }
}
