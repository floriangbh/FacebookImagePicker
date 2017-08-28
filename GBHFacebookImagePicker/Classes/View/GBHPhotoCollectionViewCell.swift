//
//  GBHPhotoCollectionViewCell.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class GBHPhotoCollectionViewCell: UICollectionViewCell {

    /// The album cover photo 
    fileprivate var albumImageView: GBHImageAsyncViewLoading?

    /// Selection hover view
    let selectView = GBHSelectedView()

    // MARK: - Lifecycle 

    /// Override the initializer 
    ///
    /// - Parameter frame: the new frame of the cell
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Cell background
        self.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor

        // Picture contener
        self.albumImageView = GBHImageAsyncViewLoading(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: 80,
                                                                     height: 80))
        self.albumImageView?.contentMode = .scaleAspectFill
        self.albumImageView?.clipsToBounds = true
        self.albumImageView?.layer.cornerRadius = GBHFacebookImagePicker.pickerConfig.pictureCornerRadius
        if let imgView = self.albumImageView {
            self.contentView.addSubview(imgView)
        }

        // Selected view 
        self.selectView.frame = self.bounds
        self.selectView.autoresizingMask = [.flexibleWidth,
                                            .flexibleHeight]
        self.contentView.addSubview(self.selectView)

        // Selected state 
        self.isSelected = false
    }

    /// Override prepare for reuse 
    override func prepareForReuse() {
        super.prepareForReuse()

        // Set default image
        self.albumImageView?.image = GBHAssetManager.getImage(name: "GBHFacebookImagePickerDefaultImageLoading")
    }

    /// Required init for deserialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure 

    /// Configure collection cell with image
    ///
    /// - Parameter picture: Facebook's image model
    func configure(picture: GBHFacebookImage) {

        // Set picture's url
        if let urlPath = picture.normalSizeUrl,
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
