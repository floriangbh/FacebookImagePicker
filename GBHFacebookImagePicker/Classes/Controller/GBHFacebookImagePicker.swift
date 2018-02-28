//
//  GBHFacebookImagePicker.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public class GBHFacebookImagePicker: NSObject {

    // Picker configuration settings
    open static var pickerConfig = GBHFacebookPickerConfig()

    /// Present album picker
    ///
    /// - Parameters:
    ///   - from: controller where we want present the picker
    ///   - delegate: delegate for GBHFacebookImagePickerDelegate
    public final func presentFacebookAlbumImagePicker(from: UIViewController,
                                                      delegate: GBHFacebookImagePickerDelegate) {

        // Create album picker
        let albumPicker = GBHFacebookAlbumPicker()
        albumPicker.delegate = delegate

        // Embed in navigation controller
        let navigationController = GBHFacebookNavigationController(rootViewController: albumPicker)

        // Present the picker 
        from.present(navigationController, animated: true)
    }

}
