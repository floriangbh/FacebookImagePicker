//
//  ViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 10/01/2016.
//  Copyright (c) 2016 Florian Gabach. All rights reserved.
//

import UIKit
import GBHFacebookImagePicker

class ViewController: UIViewController {

    // MARK: - IBOutlet 

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var showAlbumButton: UIButton!

    // MARK: - Var 

    fileprivate var imageModels = [FacebookImage]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Controlelr title 
        self.title = "Facebook Image Picker"

        // Prepare picker button
        self.showAlbumButton.setTitle("Show picker",
                                      for: .normal)
        self.showAlbumButton.setTitleColor(UIColor.white,
                                           for: .normal)
        self.showAlbumButton.layer.cornerRadius = 3.0
        self.showAlbumButton.backgroundColor = UIColor(red: 59/255.0,
                                                       green: 89/255.0,
                                                       blue: 152/255.0,
                                                       alpha: 1.0)
        self.showAlbumButton.addTarget(self,
                                       action: #selector(self.showAlbumClick),
                                       for: UIControl.Event.touchUpInside)

        // Prepare TableView 
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()

        // Background color
        self.view.backgroundColor = UIColor(red: 246/255.0,
                                            green: 246/255.0,
                                            blue: 246/255.0, alpha: 1.0)
    }

    fileprivate func someCustomisation() {
        // Navigation bar title 
        FacebookImagePicker.pickerConfig.textConfig.localizedTitle = "MyCustomTitle"

        // Navigation barTintColor
        FacebookImagePicker.pickerConfig.uiConfig.navBarTintColor = UIColor.red

        // Close button color 
        FacebookImagePicker.pickerConfig.uiConfig.closeButtonColor = UIColor.white

        // Global backgroundColor 
        FacebookImagePicker.pickerConfig.uiConfig.backgroundColor = UIColor.red

        // Navigation bar title color
        FacebookImagePicker.pickerConfig.uiConfig.navTitleColor = UIColor.white

        // Navigation bar tintColor
        FacebookImagePicker.pickerConfig.uiConfig.navTintColor = UIColor.white

        // Album's name color 
        FacebookImagePicker.pickerConfig.uiConfig.albumsTitleColor = UIColor.white

        // Album's count color 
        FacebookImagePicker.pickerConfig.uiConfig.albumsCountColor = UIColor.white

        // Maximum selected pictures 
        FacebookImagePicker.pickerConfig.maximumSelectedPictures = 4

        // Display tagged album 
        FacebookImagePicker.pickerConfig.textConfig.localizedTaggedAlbumName = "Tagged photos"

        // Tagged album name
        FacebookImagePicker.pickerConfig.displayTaggedAlbum = true

        // Number of picture per row (4 by default)
        FacebookImagePicker.pickerConfig.picturePerRow = 3

        // Space beetween album photo cell (1.5 by default)
        FacebookImagePicker.pickerConfig.cellSpacing = 2.0

        // Perform animation on picture tap (true by default)
        FacebookImagePicker.pickerConfig.performTapAnimation = true

        // Show check style with image and layer (true by default)
        FacebookImagePicker.pickerConfig.uiConfig.showCheckView = true

        // Change checkview background color
        FacebookImagePicker.pickerConfig.uiConfig.checkViewBackgroundColor = UIColor.red

        // Preview photos size (normal by default)
        FacebookImagePicker.pickerConfig.uiConfig.previewPhotoSize = .full

        // Show the "Select all" button 
        FacebookImagePicker.pickerConfig.allowAllSelection = true
    }

    // MARK: - Action

    @objc func showAlbumClick() {
        print(self, #function)

        // Init picker 
        let picker = FacebookImagePicker()

        FacebookImagePicker.pickerConfig.allowMultipleSelection = true
        FacebookImagePicker.pickerConfig.uiConfig.previewPhotoSize = .full
        FacebookImagePicker.pickerConfig.allowAllSelection = true
        FacebookImagePicker.pickerConfig.picturePerRow = 3
        FacebookImagePicker.pickerConfig.displayTaggedAlbum = true

        // Make some customisation
        //self.someCustomisation()

        // Present picker 
        picker.presentFacebookAlbumImagePicker(from: self,
                                               delegate: self)
    }

    @IBAction func doDeleteClick(_ sender: Any) {
        // Clear data src 
        self.imageModels = [FacebookImage]()
    }
}

extension ViewController: FacebookImagePickerDelegate {

    // MARK: - GBHFacebookImagePicker Protocol

    func facebookImagePicker(imagePicker: UIViewController,
                             successImageModels: [FacebookImage],
                             errorImageModels: [FacebookImage],
                             errors: [Error?]) {
        // Append selected image(s)
        // Do what you want with selected image 
        self.imageModels.append(contentsOf: successImageModels)
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCellId") as! PhotoTableViewCell
        cell.selectedImageView.image = self.imageModels[indexPath.row].image
        return cell
    }
}
