//
//  GBHImageAsyncViewLoading.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class GBHImageAsyncViewLoading: UIImageView {

    /// Initializer 
    ///
    /// - Parameter frame: imageView frame 
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set default image
        self.image = GBHAssetManager.getImage(name: GBHAssetImage.loader)
    }

    /// Required for deserialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// The image URL 
    var imageUrl: URL? {
        didSet {
            if let url = imageUrl {
                // Start url loading
                URLSession.shared.dataTask(with: url as URL) { data, response, error in
                    // In error 
                    guard let data = data, error == nil else {
                        print("\nerror on download \(String(describing: error))")
                        return
                    }

                    // Check success code (200)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        print("statusCode != 200; \(httpResponse.statusCode)")
                        return
                    }

                    // Set image 
                    DispatchQueue.main.async {
                        // Display image !
                        if let downloadedImage = UIImage(data: data) {
                            self.setImageWithAnimation(image: downloadedImage)
                        }
                    }

                    // resume task
                    }.resume()
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
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.alpha = 1.0
        }, completion: nil)
    }
}
