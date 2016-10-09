//
//  GBHFacebookImagePickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/10/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

public protocol GBHFacebookImagePickerDelegate {
    
    /**
     * Called when image is picked
     * Param :
     * - imagePicker : the picker controller
     * - url : the url of the picked picture
     **/
    func facebookImagePicker(imagePicker: UIViewController, didSelectImageWithUrl url: String)
    
    /**
     * Called when facebook picker failed
     * Param :
     * - imagePicker : the picker controller
     * - error : with description 
     **/
    func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?)
    
    /**
     * Called when facebook picker is cancelled without error
     * Param :
     * - imagePicker : the picker controller
     **/
     func facebookImagePicker(didCancelled imagePicker: UIViewController)
}
