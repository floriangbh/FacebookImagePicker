//
//  GBHFacebookImagePickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public protocol FacebookImagePickerDelegate: class {

    /// Called when one or more images are picked
    ///
    /// - Parameters:
    ///   - imagePicker: the picker controller
    ///   - successImageModels: GBHFacebookImageModels which contain image URLs, images, and image IDs
    ///   - errorImageModels: GBHFacebookImageModels which caused an error
    ///   - errors: with description
    func facebookImagePicker(
        imagePicker: UIViewController,
        successImageModels: [FacebookImage],
        errorImageModels: [FacebookImage],
        errors: [Error?]
    )

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
public extension FacebookImagePickerDelegate {
    func facebookImagePickerDismissed() {
        // Override in your controller to make your own implementation ! 
    }

    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        // Override in your controller to make your own implementation ! 
    }
}
