//
//  FacebookAlbumPickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import Foundation

protocol FacebookAlbumPickerDelegate: class {
    func didSelectAlbum(album: FacebookAlbum)
}
