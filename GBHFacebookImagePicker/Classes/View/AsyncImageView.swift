//
//  AsyncImageView.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class AsyncImageView: UIImageView {

    /// Initializer 
    ///
    /// - Parameter frame: imageView frame 
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set default image
        self.image = AssetsController.getImage(name: AssetImage.loader)
    }

    /// Required for deserialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// The image URL 
    var imageUrl: URL? {
        didSet {
            if let url = imageUrl {

                if let cachedImage = ImageCacheController.shared.getImage(forUrl: url.absoluteString) {
                    // Retrieved image from cache 
                    self.image = cachedImage
                } else {
                    // Image aren't in the cache, let's download it 
                    // Start url loading
                    URLSession.shared.dataTask(with: url as URL) { [weak self] data, response, error in
                        // Get strong self 
                        guard let strongSelf = self else {
                            print("Can't get strong self.")
                            return
                        }

                        // In error 
                        guard let data = data, error == nil else {
                            print("Error on download \(String(describing: error))")
                            return
                        }

                        // Check success code (200)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                            print("statusCode != 200 : \(httpResponse.statusCode)")
                            return
                        }

                        DispatchQueue.main.async {
                            // Display the image !
                            if let downloadedImage = UIImage(data: data) {
                                // Cache the image 
                                ImageCacheController.shared.setImage(forUrl: url.absoluteString,
                                                                     image: downloadedImage)

                                // Set the image with animation
                                strongSelf.setImageWithAnimation(image: downloadedImage)
                            }
                        }

                        // resume task
                        }.resume()
                }
            }
        }
    }

    /// Set the image with animation
    ///
    /// - Parameter image: the image to set
    fileprivate func setImageWithAnimation(image: UIImage) {

        // Set initial state 
        self.image = image
        self.alpha = 0

        // Start animation to final state 
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.alpha = 1.0
        }, completion: nil)
    }
}
