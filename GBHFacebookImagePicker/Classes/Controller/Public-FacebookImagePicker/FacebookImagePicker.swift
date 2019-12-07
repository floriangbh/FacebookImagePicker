//
//  GBHFacebookImagePicker.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public class FacebookImagePicker: NSObject {

    // Picker configuration settings
    public static var pickerConfig = FacebookPickerConfig()

    private var facebookController = FacebookController()

    /// Present album picker
    ///
    /// - Parameters:
    ///   - from: controller where we want present the picker
    ///   - delegate: delegate for GBHFacebookImagePickerDelegate
    public final func presentFacebookAlbumImagePicker(from: UIViewController,
                                                      delegate: FacebookImagePickerDelegate) {
        from.present(getFacebookAlbumImagePicker(delegate: delegate), animated: true)
    }

    /// Get album picker
    ///
    /// - Parameters:
    ///   - delegate: delegate for GBHFacebookImagePickerDelegate
    /// - Returns: The album picker controller
    public final func getFacebookAlbumImagePicker(delegate: FacebookImagePickerDelegate) -> UIViewController {

        // Create album picker
        let albumPicker = FacebookAlbumController(facebookController: facebookController)
        albumPicker.delegate = delegate

        // Embed in navigation controller
        let navigationController = FacebookImagePickerNavigationController(rootViewController: albumPicker)

        return navigationController
    }
}
