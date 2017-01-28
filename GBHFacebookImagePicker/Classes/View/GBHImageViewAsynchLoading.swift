//
//  GBHImageAsyncViewLoading.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class GBHImageAsyncViewLoading: UIImageView {
    
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
    
    /// Set with animation
    ///
    /// - Parameter image: the image to set
    fileprivate func setImageWithAnimation(image: UIImage) {
        self.image = image
         self.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}
