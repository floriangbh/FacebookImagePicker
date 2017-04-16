//
//  GBHFacebookImagePicker.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public class GBHFacebookImagePicker: NSObject {

    // Picker configuration settings
    public static var pickerConfig = GBHFacebookPickerConfig()

    /// Present album picker
    ///
    /// - Parameters:
    ///   - from: controller where we want present the picker
    ///   - delegate: delegate for GBHFacebookImagePickerDelegate
    public final func presentFacebookAlbumImagePicker(from: UIViewController, navBgColor:UIColor?, delegate: GBHFacebookImagePickerDelegate) {

        // Create album picker
        let albumPicker = GBHFacebookAlbumPicker()
        albumPicker.delegate = delegate

        // Embed in navigation controller
        let navi = GBHFacebookNavigationController(rootViewController: albumPicker)
        
        // Set Custom NavigationBar Background Color here if you'd like.
        if navBgColor != nil {
            navi.navigationBar.backgroundColor = navBgColor
        }
        
        
        from.present(navi, animated: true)
    }

}
