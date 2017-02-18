//
//  GBHNotificationName.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

/// Custom notification identifier
///
/// GBHFacebookImagePickerDidRetrieveAlbum : When album did finish loading
/// GBHFacebookImagePickerDidRetriveAlbumPicture : When album's picture did finish loading
extension Notification.Name {
    static let ImagePickerDidRetrieveAlbum = Notification.Name("GBHFacebookImagePickerDidRetrieveAlbum")
    static let ImagePickerDidRetriveAlbumPicture = Notification.Name("GBHFacebookImagePickerDidRetriveAlbumPicture")
}
