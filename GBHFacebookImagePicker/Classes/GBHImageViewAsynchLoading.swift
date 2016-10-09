//
//  GBHImageAsyncViewLoading.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

class GBHImageAsyncViewLoading: UIImageView {
    
    var imageUrl: URL? {
        didSet {
            // Set default image
            self.image = GBHAssetManager.getImage(name: "GBHFacebookImagePickerDefaultImageLoading")
            
            if let url = imageUrl {
                // Start url loading
                URLSession.shared.dataTask(with: url as URL) { data, response, error in
                    guard let data = data , error == nil else {
                        print("\nerror on download \(error)")
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        print("statusCode != 200; \(httpResponse.statusCode)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data) // Display image !
                    }
                    }.resume()
            }
        }
    }
}


