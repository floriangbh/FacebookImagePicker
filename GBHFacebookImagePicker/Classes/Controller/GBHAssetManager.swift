//
//  GBHAssetManager.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 02/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

public class GBHAssetManager {
    
    /// Get image from bundle
    ///
    /// - Parameter name: name of the image
    /// - Returns: optional image 
    public static func getImage(name: String) -> UIImage? {        
        var bundle = Bundle(for: GBHAssetManager.self)
        if let bundlePath = bundle.resourcePath?.appending("/GBHFacebookImagePicker.bundle"), let ressourceBundle = Bundle(path: bundlePath) {
            bundle = ressourceBundle
        }

        return UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
