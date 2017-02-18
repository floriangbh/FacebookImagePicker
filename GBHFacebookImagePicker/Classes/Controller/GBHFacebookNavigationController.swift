//
//  GBHFacebookNavigationController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 09/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class GBHFacebookNavigationController: UINavigationController {

    // MARK: - Lifecycle

    /// Initialize the navigation controller after didLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set style
        switch GBHFacebookImagePicker.pickerConfig.ui.style {
        case .facebook:
            // Facebook style
            self.navigationBar.barTintColor = GBHAppearanceManager.facebookColor
            self.navigationBar.tintColor = GBHAppearanceManager.whiteCustom
            self.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: GBHAppearanceManager.whiteCustom
            ]
        case .dark:
            // Dark style
            self.navigationBar.barTintColor = GBHAppearanceManager.black
            self.navigationBar.tintColor = GBHAppearanceManager.whiteCustom
            self.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: GBHAppearanceManager.whiteCustom
            ]
        case .light:
            // Light style
            self.navigationBar.barTintColor = GBHAppearanceManager.whiteCustom
            self.navigationBar.tintColor = GBHAppearanceManager.black
            self.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: GBHAppearanceManager.black
            ]
        }
    }
}
