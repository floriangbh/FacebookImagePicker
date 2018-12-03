//
//  FacebookAlbumPickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/12/2018.
//

import Foundation

protocol FacebookAlbumDetailPickerDelegate: class {
    func didSelectImage(image: FacebookImage)
    func didPressFinishSelection() 
}
