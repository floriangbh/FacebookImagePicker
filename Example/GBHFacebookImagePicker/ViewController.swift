//
//  ViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 10/01/2016.
//  Copyright (c) 2016 Florian Gabach. All rights reserved.
//

import UIKit
import GBHFacebookImagePicker

class ViewController: UIViewController, GBHFacebookImagePickerDelegate {

    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var showAlbumButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare picker button
        self.showAlbumButton.setTitle("Show picker", for: .normal)
        self.showAlbumButton.setTitleColor(UIColor.white, for: .normal)
        self.showAlbumButton.layer.cornerRadius = 3.0
        self.showAlbumButton.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
        self.showAlbumButton.addTarget(self,
                                       action: #selector(self.showAlbumClick),
                                       for: UIControlEvents.touchUpInside)

        // Background color
        self.view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)

        // Default image
        self.pickerImageView.image = UIImage(named: "bigLogo")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showAlbumClick() {
        print(self, #function)

        // Init & Show picker
        let picker = GBHFacebookImagePicker()
        GBHFacebookImagePicker.pickerConfig.ui.style = .facebook
        picker.presentFacebookAlbumImagePicker(from: self, delegate: self)
    }

    // MARK: - GBHFacebookImagePicker Protocol

    func facebookImagePicker(imagePicker: UIViewController, 
                             imageModel: GBHFacebookImage) {
        print("Image URL : \(String(describing: imageModel.fullSizeUrl)), Image Id: \(String(describing: imageModel.imageId))")
        if let pickedImage = imageModel.image {
            self.pickerImageView.image = pickedImage
        }
    }

    func facebookImagePicker(imagePicker: UIViewController, didFailWithError error: Error?) {
        print("Cancelled Facebook Album picker with error")
        print(error.debugDescription)
    }

    // Optional
    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        print("Cancelled Facebook Album picker")
    }

    // Optional
    func facebookImagePickerDismissed() {
        print("Picker dismissed")
    }
}
