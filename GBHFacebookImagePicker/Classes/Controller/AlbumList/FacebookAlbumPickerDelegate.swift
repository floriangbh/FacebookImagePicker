//
//  FacebookAlbumPickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import Foundation

protocol FacebookAlbumPickerDelegate: class {
    /// Perform when picture are selected in the displayed album
    ///
    /// - parameter imageModel: model of the selected picture
    func didSelecPicturesInAlbum(imageModels: [GBHFacebookImage])

    /// Failed to select picture in album
    ///
    /// - parameter error: error
    func didFailSelectPictureInAlbum(error: Error?)
}
