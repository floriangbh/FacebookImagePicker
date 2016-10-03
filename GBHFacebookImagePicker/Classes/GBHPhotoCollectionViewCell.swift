//
//  GBHPhotoCollectionViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

class GBHPhotoCollectionViewCell: UICollectionViewCell {
    
    var imageView: GBHImageAsyncViewLoading!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add imageView for add Photo
        self.imageView = GBHImageAsyncViewLoading(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
    }
    
    func configure(picture: GBHFacebookImageModel) {
        if let urlPath = picture.link,
            let url = URL(string: urlPath) {
            self.imageView?.imageUrl = url
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
