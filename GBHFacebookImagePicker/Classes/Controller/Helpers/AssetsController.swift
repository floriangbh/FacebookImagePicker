//
//  AssetsController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 02/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

final class AssetsController {

    /// Get image from bundle
    ///
    /// - parameter name: name of the image
    ///
    /// - returns: return the retrieved image 
    public static func getImage(name: String) -> UIImage? {
        var bundle = Bundle(for: AssetsController.self)
        if let bundlePath = bundle.resourcePath?.appending("/GBHFacebookImagePicker.bundle"),
            let ressourceBundle = Bundle(path: bundlePath) {
            bundle = ressourceBundle
        }

        if let imageFromBundle = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return imageFromBundle
        }

        print("Failed to get \(name) from bundle :-(")
        return UIImage()
    }
}
