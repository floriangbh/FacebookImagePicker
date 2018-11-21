//
//  GBHFacebookImagePicker.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public class FacebookImagePicker: NSObject {

    // Picker configuration settings
    open static var pickerConfig = FacebookPickerConfig()
    
    fileprivate var facebookController = FacebookController()

    /// Present album picker
    ///
    /// - Parameters:
    ///   - from: controller where we want present the picker
    ///   - delegate: delegate for GBHFacebookImagePickerDelegate
    public final func presentFacebookAlbumImagePicker(from: UIViewController,
                                                      delegate: FacebookImagePickerDelegate) {

        // Create album picker
        let albumPicker = FacebookAlbumController(facebookController: facebookController)
        albumPicker.delegate = delegate

        // Embed in navigation controller
        let navigationController = FacebookImagePickerNavigationController(rootViewController: albumPicker)

        // Present the picker 
        from.present(navigationController, animated: true)
    }

}
