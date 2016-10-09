//
//  GBHFacebookPickerCustomError.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 30/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case LoginCancelled // When login webview are cancelled before login
    case PermissionDenied // When user_photos permission are denied
    case LoginFailed // When Facebook login fail
}
