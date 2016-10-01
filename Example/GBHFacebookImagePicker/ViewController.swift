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
    
    @IBOutlet weak var showAlbumButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Prepare picker button
        self.showAlbumButton.addTarget(self,
                                       action: #selector(self.showAlbumClick),
                                       for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlbumClick() {
        print(self, #function)
        
        // Init & Show picker
        let albumPicker = GBHFacebookImagePicker()
        albumPicker.delegate = self
        let navi = UINavigationController(rootViewController: albumPicker)
        self.present(navi, animated: true)
    }
    
    // MARK: - GBHFacebookImagePicker Protocol
    
    func facebookImagePicker(imagePicker: UIViewController, didSelectImageWithUrl url: String) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        print("Image URL : \(url)")
    }

}

