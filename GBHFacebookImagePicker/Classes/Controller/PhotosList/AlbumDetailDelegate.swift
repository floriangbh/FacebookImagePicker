//
//  AlbumDetailListDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 21/11/2018.
//

import Foundation

protocol AlbumDetailDelegate: class {
    func didSelectImage(image: FacebookImage)
    func didDeselectImage(image: FacebookImage)
    func shouldSelectImage() -> Bool
}
