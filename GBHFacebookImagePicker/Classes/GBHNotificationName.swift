//
//  GBHNotificationName.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import Foundation

/**
 * Custom notification identifier
 * GBHFacebookImagePickerDidRetrieveAlbum -> When album did finish loading
 * GBHFacebookImagePickerDidRetriveAlbumPicture -> When album's picture did finish loading
 **/
extension Notification.Name {
    static let GBHFacebookImagePickerDidRetrieveAlbum = Notification.Name("GBHFacebookImagePickerDidRetrieveAlbum")
    static let GBHFacebookImagePickerDidRetriveAlbumPicture = Notification.Name("GBHFacebookImagePickerDidRetriveAlbumPicture")
}
