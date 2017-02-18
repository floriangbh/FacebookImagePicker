//
//  GBHFacebookPickerCustomError.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 30/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

/// All the error type 
///
/// - loginCancelled: When login webview are cancelled before login
/// - permissionDenied: When user_photos permission are denied
/// - loginFailed: When Facebook login fail
enum LoginError: Error {
    case loginCancelled
    case permissionDenied
    case loginFailed
}
