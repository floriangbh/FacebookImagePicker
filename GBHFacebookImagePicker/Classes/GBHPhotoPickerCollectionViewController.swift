//
//  GBHPhotoPickerCollectionViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

class GBHPhotoPickerCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: Var
    fileprivate var indicator = UIActivityIndicatorView()
    fileprivate let reuseIdentifier = "Cell"
    fileprivate var pictureCollection: UICollectionView?
    var albumPictureDelegate: GBHAlbumPickerTableViewControllerDelegate?
    fileprivate var imageArray: [GBHFacebookImageModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pictureCollection?.reloadData()
            }
        }
    }
    var album: GBHFacebookAlbumModel?
    
    // MARK: Init & Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceivePicture(_:)),
                                               name: Notification.Name.GBHFacebookImagePickerDidRetriveAlbumPicture,
                                               object: nil)
        
        // Prepare view
        self.prepareViewController()
        
        // Fetch photos
        self.getPhotos()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareViewController() {
        self.title = self.album?.name ?? NSLocalizedString("Photos", comment: "")
        
        self.prepareCollectionView()
        self.prepareActivityIndicator()
        self.startLoading()
    }
    
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.pictureCollection?.register(GBHPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.pictureCollection?.delegate = self
        self.pictureCollection?.dataSource = self
        self.view.addSubview(self.pictureCollection!)
        self.pictureCollection?.backgroundColor = UIColor.white
    }
    
    fileprivate func getPhotos() {
        if let album = self.album {
            GBHFacebookHelper.shared.fbAlbumsPictureRequest(after: nil, album: album)
            self.stopLoading()
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
        self.indicator.backgroundColor = UIColor.white
    }
    
    fileprivate func stopLoading() {
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    // MARK: - Action
    
    @objc fileprivate func didReceivePicture(_ sender: Notification) {
        if let album = sender.object as? GBHFacebookAlbumModel, self.album?.id == album.id {
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
        if let url = self.imageArray[indexPath.row].link {
            self.albumPictureDelegate?.didSelecPictureInAlbum(url: url)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GBHPhotoCollectionViewCell
        if cell == nil {
            cell = GBHPhotoCollectionViewCell()
        }
    
        if let urlPath = self.imageArray[indexPath.row].link,
            let url = URL(string: urlPath) {
                  cell?.imageView.imageUrl = url
        }
    
        return cell!
    }
}
