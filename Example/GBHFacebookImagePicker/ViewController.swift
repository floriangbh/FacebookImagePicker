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

    fileprivate var imageModels = [GBHFacebookImage]() {
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
                                       for: UIControlEvents.touchUpInside)

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
        GBHFacebookImagePicker.pickerConfig.title = "MyCustomTitle"

        // Navigation barTintColor
        GBHFacebookImagePicker.pickerConfig.uiConfig.navBarTintColor = UIColor.red

        // Close button color 
        GBHFacebookImagePicker.pickerConfig.uiConfig.closeButtonColor = UIColor.white

        // Global backgroundColor 
        GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor = UIColor.red

        // Navigation bar title color
        GBHFacebookImagePicker.pickerConfig.uiConfig.navTitleColor = UIColor.white

        // Navigation bar tintColor
        GBHFacebookImagePicker.pickerConfig.uiConfig.navTintColor = UIColor.white

        // Album's name color 
        GBHFacebookImagePicker.pickerConfig.uiConfig.albumsTitleColor = UIColor.white

        // Album's count color 
        GBHFacebookImagePicker.pickerConfig.uiConfig.albumsCountColor = UIColor.white

        // Selected border color 
        GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderColor = UIColor.red

        // Selected border width 
        GBHFacebookImagePicker.pickerConfig.uiConfig.selectedBorderWidth = 4.0
        
        // Maximum selected pictures 
        GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 4
        
        // Display tagged album 
        GBHFacebookImagePicker.pickerConfig.taggedAlbumName = "Tagged photos"
        
        // Tagged album name
        GBHFacebookImagePicker.pickerConfig.displayTaggedAlbum = true
    }

    // MARK: - Action

    func showAlbumClick() {
        print(self, #function)

        // Init picker 
        let picker = GBHFacebookImagePicker()

        // Allow multiple selection (false by default)
        GBHFacebookImagePicker.pickerConfig.allowMultipleSelection = true
        GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 4
        GBHFacebookImagePicker.pickerConfig.displayTaggedAlbum = false

        // Make some customisation
        // self.someCustomisation()

        // Present picker 
        picker.presentFacebookAlbumImagePicker(from: self,
                                               delegate: self)
    }

    @IBAction func doDeleteClick(_ sender: Any) {
        // Clear data src 
        self.imageModels = [GBHFacebookImage]()
    }
}

extension ViewController: GBHFacebookImagePickerDelegate {

    // MARK: - GBHFacebookImagePicker Protocol

    func facebookImagePicker(imagePicker: UIViewController,
                             successImageModels: [GBHFacebookImage],
                             errorImageModels: [GBHFacebookImage],
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
