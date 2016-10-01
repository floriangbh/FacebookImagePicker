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
        
        imageView = GBHImageAsyncViewLoading(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.contentMode = UIViewContentMode.scaleToFill
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
