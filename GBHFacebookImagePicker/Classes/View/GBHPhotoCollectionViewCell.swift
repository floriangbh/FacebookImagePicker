//
//  GBHPhotoCollectionViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
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

class GBHPhotoCollectionViewCell: UICollectionViewCell {
    
    fileprivate var albumImageView: GBHImageAsyncViewLoading?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = GBHFacebookImagePicker.pickerConfig.ui.backgroundColor
        
        // Picture contener
        self.albumImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.albumImageView?.contentMode = .scaleAspectFill
        self.albumImageView?.clipsToBounds = true
        self.albumImageView?.layer.cornerRadius = GBHAppearanceManager.pictureCornerRadius
        if let imgView = self.albumImageView {
            self.contentView.addSubview(imgView)
        }
    }
    
    /// Configure collection cell with image
    ///
    /// - Parameter picture: Facebook's image model
    func configure(picture: GBHFacebookImageModel) {
        
        // Set picture's url
        if let urlPath = picture.normalSizeUrl,
            let url = URL(string: urlPath) {
            self.albumImageView?.imageUrl = url
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
