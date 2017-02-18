//
//  GBHPhotoPickerViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

class GBHPhotoPickerViewController: UIViewController {

    /// MARK: Var

    /// Loading indicator 
    fileprivate var indicator = UIActivityIndicatorView()

    /// Cell identifier 
    fileprivate let reuseIdentifier = "Cell"

    /// The collection view where are display the pictures 
    fileprivate var pictureCollection: UICollectionView? // Collection for display album's pictures

    /// Array which contain image model of pictures which are in the album
    fileprivate var imageArray: [GBHFacebookImage] = [] {
        didSet {
            // Reload the collection
            DispatchQueue.main.async {
                self.pictureCollection?.reloadData()
            }
        }
    }

    /// Album picker controller delegate 
    weak var albumPictureDelegate: GBHAlbumPickerTableViewControllerDelegate?

    // Current album model 
    var album: GBHFacebookAlbum? // Curent album

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare view
        self.prepareViewController()
        self.prepareObserver()

        // Fetch photos if empty
        self.getPhotos()
    }

    // MARK: Prepare

    /// Prepare the observe 
    /// Permit to detect when the pictures of the album did finish loading
    fileprivate func prepareObserver() {
        // Orbserve end of picture loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceivePicture(_:)),
                                               name: Notification.Name.ImagePickerDidRetriveAlbumPicture,
                                               object: nil)

    }

    /// Prepare the UIViewController 
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

    /// Set the collection view constraint 
    fileprivate func prepareCollectionViewConstraint() {
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

    /// Prepare UIActivityIndicatorView and display it at the center of the view
    fileprivate func prepareActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 40, height: 40) )
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
    }

    /// Start loading : start the loader animation 
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.color = UIColor.black
    }

    /// Stop loading : stop and hide the loader
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
        if let album = sender.object as? GBHFacebookAlbum,
            self.album?.albumId == album.albumId {
            self.imageArray = album.photos
        }
    }
}

extension GBHPhotoPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDelegate & UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
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

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? GBHPhotoCollectionViewCell
        if cell == nil {
            cell = GBHPhotoCollectionViewCell()
        }

        // Configure cell with image
        cell?.configure(picture: self.imageArray[indexPath.row])

        return cell!
    }

}

extension GBHPhotoPickerViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

}
