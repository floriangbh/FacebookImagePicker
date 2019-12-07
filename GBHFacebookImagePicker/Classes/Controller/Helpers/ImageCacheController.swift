//
//  GBHCacheManager.swift
//  Bolts
//
//  Created by Florian Gabach on 12/09/2017.
//

import Foundation

final class ImageCacheController {

    // MARK: - Singleton 

    static let shared = ImageCacheController()

    // MARK: - Var 

    private let imageCache = NSCache<NSString, AnyObject>()

    // Method 

    /// Set image to the cache
    ///
    /// - Parameters:
    ///   - url: url of the image 
    ///   - image: image to add to the cache 
    func setImage(forUrl url: String,
                  image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    /// Retrieve image from cache based on the url 
    ///
    /// - Parameter url: url of the image 
    /// - Returns: the retrieve image or nil if doesn't exist 
    func getImage(forUrl url: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: url as NSString) as? UIImage {
            return cachedImage
        }

        return nil
    }
}
