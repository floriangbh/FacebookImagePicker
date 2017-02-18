//
//  GBHAssetManager.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 02/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

public class GBHAssetManager {

    /// Get image from bundle
    ///
    /// - parameter name: name of the image
    ///
    /// - returns: return the retrieved image 
    public static func getImage(name: String) -> UIImage? {

        // Retrieved the main bundle
        var bundle = Bundle(for: GBHAssetManager.self)
        if let bundlePath = bundle.resourcePath?.appending("/GBHFacebookImagePicker.bundle"),
            let ressourceBundle = Bundle(path: bundlePath) {

            // Bundle with the new path
            bundle = ressourceBundle
        }

        // Return the bundle image
        return UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
