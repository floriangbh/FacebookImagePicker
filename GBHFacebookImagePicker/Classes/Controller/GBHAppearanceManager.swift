//
//  GBHAppearanceManager.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 07/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

class GBHAppearanceManager: NSObject {
    // White color : http://www.color-hex.com/color/ffffff
    static let whiteCustom = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)

    // Facebook color : http://www.color-hex.com/color/3b5998
    static let facebookColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)

    // Black color  : http://www.color-hex.com/color/000000
    static let black = UIColor.black

    // The picture corner raidius. Used for display album cover and album's picture.
    static let pictureCornerRadius: CGFloat = 2.0
}

/// PickerStyle is the UI style of the picker.
///
/// - facebook: white title and Facebook's blue color for the navigation bar.
/// - light: black title and white navigation bar.
/// - dark: white title and dark navigation bar.
public enum PickerStyle {
    case facebook
    case light
    case dark
}
