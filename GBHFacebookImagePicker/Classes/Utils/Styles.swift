//
//  Styles.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 07/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

struct Styles {
    // White color : http://www.color-hex.com/color/ffffff
    static let whiteCustom = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)

    // Facebook color : http://www.color-hex.com/color/3b5998
    static let facebookColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)

    // Black color  : http://www.color-hex.com/color/000000
    var label: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    var backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
    
    var loaderStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView.Style.medium
        } else {
            return UIActivityIndicatorView.Style.gray
        }
    }
}
