//
//  GBHImageAsyncViewLoading.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class GBHImageAsyncViewLoading: UIImageView {

    /// The image URL 
    var imageUrl: URL? {
        didSet {
            // Set default image
            self.image = GBHAssetManager.getImage(name: "GBHFacebookImagePickerDefaultImageLoading")

            if let url = imageUrl {
                // Start url loading
                URLSession.shared.dataTask(with: url as URL) { data, response, error in
                    guard let data = data, error == nil else {
                        print("\nerror on download \(error)")
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        print("statusCode != 200; \(httpResponse.statusCode)")
                        return
                    }
                    DispatchQueue.main.async {
                        // Display image !
                        if let downloadedImage = UIImage(data: data) {
                            self.setImageWithAnimation(image: downloadedImage)
                        }
                    }
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
