//
//  FacebookImagePickerNavigationController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

final class FacebookImagePickerNavigationController: UINavigationController {

    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return FacebookImagePicker.pickerConfig.uiConfig.statusbarStyle
    }

    // MARK: - Lifecycle

    /// Initialize the navigation controller after didLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply barTintColor if specified in config struct 
        if let barTintColor = FacebookImagePicker.pickerConfig.uiConfig.navBarTintColor {
            self.navigationBar.barTintColor = barTintColor
            self.navigationBar.isTranslucent = false
        }

        // Apply tintColor if specified in config struct 
        if let tintColor = FacebookImagePicker.pickerConfig.uiConfig.navTintColor {
            self.navigationBar.tintColor = tintColor
        }

        // Apply navigation bar title color if specified in config struct 
        if let tintColor = FacebookImagePicker.pickerConfig.uiConfig.navTitleColor {
            self.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor
            ]
        }
    }
}
