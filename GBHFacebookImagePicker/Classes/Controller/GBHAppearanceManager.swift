//
//  GBHAppearanceManager.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 07/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public enum PickerStyle {
    case facebook
    case light
    case dark
}

class GBHAppearanceManager: NSObject {
    static let whiteCustom = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
    static let facebookColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    static let black = UIColor.black

    static let pictureCornerRadius: CGFloat = 2.0
}
