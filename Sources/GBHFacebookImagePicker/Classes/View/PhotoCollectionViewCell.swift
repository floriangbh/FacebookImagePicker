//
//  PhotoCollectionViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, Reusable {
    
    /// The album cover photo 
    private var albumImageView: AsyncImageView?
    
    /// Selection hover view
    let selectView = SelectedView()
    
    // MARK: - Lifecycle 
    
    /// Override the initializer 
    ///
    /// - Parameter frame: the new frame of the cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Cell background
        self.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        
        // Picture contener
        self.albumImageView = AsyncImageView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: self.frame.width,
                                                                  height: self.frame.height))
        self.albumImageView?.contentMode = .scaleAspectFill
        self.albumImageView?.clipsToBounds = true
        self.albumImageView?.layer.cornerRadius = FacebookImagePicker.pickerConfig.pictureCornerRadius
        if let imgView = self.albumImageView {
            self.contentView.addSubview(imgView)
        }
        
        // Selected view 
        self.selectView.frame = self.bounds
        self.selectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.selectView)
        
        // Selected state 
        self.isSelected = false
    }
    
    /// Override prepare for reuse 
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Set default image
        self.albumImageView?.image = AssetsController.getImage(name: AssetImage.loader)
    }
    
    /// Required init for deserialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure 
    
    /// Configure collection cell with image
    ///
    /// - Parameter picture: Facebook's image model
    func configure(picture: FacebookImage) {
        // Set picture's url
        let urlPath = FacebookImagePicker.pickerConfig.uiConfig.previewPhotoSize == .normal
            ? picture.normalSizeUrl : picture.fullSizeUrl
        if let urlPath = urlPath,
            let url = URL(string: urlPath) {
            self.albumImageView?.imageUrl = url
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.selectView.isHidden = !super.isSelected
        }
    }
}
