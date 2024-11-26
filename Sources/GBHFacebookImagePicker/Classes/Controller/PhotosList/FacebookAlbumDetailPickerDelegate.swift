//
//  FacebookAlbumPickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/12/2018.
//

import Foundation

protocol FacebookAlbumDetailPickerDelegate: AnyObject {
    func didSelectImages(images: [FacebookImage])
    func didPressFinishSelection(images: [FacebookImage])
}
