//
//  GBHPhotoPickerViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class GBHPhotoPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: Var
    
    fileprivate var indicator = UIActivityIndicatorView()
    fileprivate let reuseIdentifier = "Cell"
    fileprivate var pictureCollection: UICollectionView? // Collection for display album's pictures
    fileprivate var imageArray: [GBHFacebookImageModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pictureCollection?.reloadData()
            }
        }
    }
    
    var albumPictureDelegate: GBHAlbumPickerTableViewControllerDelegate?
    var album: GBHFacebookAlbumModel? // Curent album
    
    // MARK: Init & Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare view
        self.prepareViewController()
        self.prepareObserver()
        
        // Fetch photos if empty
        self.getPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Prepare
    
    fileprivate func prepareObserver() {
        // Orbserve end of picture loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceivePicture(_:)),
                                               name: Notification.Name.ImagePickerDidRetriveAlbumPicture,
                                               object: nil)
        
    }
    
    fileprivate func prepareViewController() {
        self.title = self.album?.name ?? NSLocalizedString("Pictures", comment: "")
        self.view.backgroundColor = GBHFacebookImagePicker.pickerConfig.ui.backgroundColor
        
        self.prepareCollectionView()
        self.prepareActivityIndicator()
        self.startLoading()
    }
    
    /// Prepare pictureCollection which will contains album's pictures
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.pictureCollection?.register(GBHPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.pictureCollection?.delegate = self
        self.pictureCollection?.dataSource = self
        self.pictureCollection?.backgroundColor = UIColor.white
        self.pictureCollection?.translatesAutoresizingMaskIntoConstraints = false
        if let collection = self.pictureCollection {
            self.view.addSubview(collection)
            self.prepareCollectionViewConstraint()
        }
    }
    
    func prepareCollectionViewConstraint() {
        // Top constraint
        if let collection = self.pictureCollection {
            self.view.addConstraint(NSLayoutConstraint(item: collection,
                                                       attribute: NSLayoutAttribute.top,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.top,
                                                       multiplier: 1,
                                                       constant: 0))
            
            // Bottom constraint
            self.view.addConstraint(NSLayoutConstraint(item: collection,
                                                       attribute: NSLayoutAttribute.bottom,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.bottom,
                                                       multiplier: 1,
                                                       constant: 0))
            
            // Leading constraint
            self.view.addConstraint(NSLayoutConstraint(item: collection,
                                                       attribute: NSLayoutAttribute.leading,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.leading,
                                                       multiplier: 1,
                                                       constant: 0))
            
            // Trainling constraint
            self.view.addConstraint(NSLayoutConstraint(item: collection,
                                                       attribute: NSLayoutAttribute.trailing,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.trailing,
                                                       multiplier: 1,
                                                       constant: 0))
        }
    }
    
    // MARK: - Loading indicator
    
    fileprivate func prepareActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 40, height: 40) )
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.color = UIColor.black
    }
    
    fileprivate func stopLoading() {
        self.indicator.hidesWhenStopped = true
        self.indicator.stopAnimating()
    }
    
    // MARK: - Action
    
    /// Start request for album's pictures
    fileprivate func getPhotos() {
        if let photosArray = self.album?.photos {
            self.imageArray = photosArray
            if imageArray.isEmpty {
                self.startLoading()
                if let album = self.album {
                    GBHFacebookHelper.shared.fbAlbumsPictureRequest(after: nil, album: album)
                } else {
                    self.albumPictureDelegate?.didFailSelectPictureInAlbum(error: nil)
                }
            } else {
                self.stopLoading()
            }
        }
    }
    
    /// Did finish get album's pictures callback
    @objc fileprivate func didReceivePicture(_ sender: Notification) {
        self.stopLoading()
        if let album = sender.object as? GBHFacebookAlbumModel, self.album?.albumId == album.albumId {
            self.imageArray = album.photos
        }
    }
    
    // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Set sellection style
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = .none
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        // Get the selected image
        let imageModel = self.imageArray[indexPath.row]
        
        // Clean collection and start loading
        self.imageArray = []
        self.startLoading()
        self.pictureCollection?.reloadData()
            
        // Send to album delegate for download
        self.albumPictureDelegate?.didSelecPictureInAlbum(imageModel: imageModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GBHPhotoCollectionViewCell
        if cell == nil {
            cell = GBHPhotoCollectionViewCell()
        }
        
        // Configure cell with image
        cell?.configure(picture: self.imageArray[indexPath.row])
        
        return cell!
    }
}
