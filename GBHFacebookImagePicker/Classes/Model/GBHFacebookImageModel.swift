//
//  GBHFacebookImageModel.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import Foundation

public class GBHFacebookImageModel {
    
    // MARK: - Var
    
    public var image: UIImage? // The image, not nil only if image is selected
    public var normalSizeUrl: String? // Normal size picture url
    public var fullSizeUrl: String? // Full size source picture url
    public var imageId: String? // Picture id
    
    // MARK: - Init
    
    init(picture: String, imgId: String, source: String) {
        self.imageId = imgId
        self.normalSizeUrl = picture
        self.fullSizeUrl = source
    }
}
