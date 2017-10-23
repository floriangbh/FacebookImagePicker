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

    /// Cell size 
    fileprivate var cellSize: CGFloat?

    /// Number of cell for each row 
    fileprivate let cellPerRow: CGFloat = GBHFacebookImagePicker.pickerConfig.picturePerRow

    /// Spacing beetween cell 
    fileprivate let cellSpacing: CGFloat = GBHFacebookImagePicker.pickerConfig.cellSpacing

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

    /// Did already load album 
    fileprivate var alreadyLoaded: Bool = false

    /// Album picker controller delegate 
    weak var albumPictureDelegate: GBHAlbumPickerTableViewControllerDelegate?

    // Current album model 
    var album: GBHFacebookAlbum? // Curent album

    //
    public var selectedImages = [GBHFacebookImage]() {
        didSet {
            // How many image selected
            let count = self.selectedImages.count

            // Manage disable/enable state 
            if count > 0 {
                self.selectBarButton?.isEnabled = true
            } else {
                self.selectBarButton?.isEnabled = false
            }

            // Update button title 
            self.selectBarButton?.title = "Select\(count > 0 ? " (\(count))" : "")"
        }
    }

    //
    fileprivate(set) var selectBarButton: UIBarButtonItem?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare view
        self.prepareViewController()
        self.prepareObserver()

        // Fetch photos if empty
        self.getPhotos()
    }

    deinit {
        // Remove picture loading observer 
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.ImagePickerDidRetriveAlbumPicture,
                                                  object: nil)
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
        // Title & Background
        self.title = self.album?.name ?? NSLocalizedString("Pictures", comment: "")
        self.view.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor

        // Prepare component 
        self.prepareCollectionView()
        self.prepareActivityIndicator()
        self.prepareMultipleSelectionButton()

        // Start loading 
        self.startLoading()
    }

    fileprivate func prepareMultipleSelectionButton() {
        if GBHFacebookImagePicker.pickerConfig.allowMultipleSelection {
            self.selectBarButton = UIBarButtonItem(
                title: "Select",
                style: .plain,
                target: self,
                action: #selector(actionSelectBarButton(sender:))
            )
            self.selectBarButton?.isEnabled = false
            if let barButton = self.selectBarButton {
                self.navigationItem.rightBarButtonItems = [barButton]
            }
        }
    }

    /// Prepare pictureCollection which will contains album's pictures
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds,
                                                  collectionViewLayout: layout)
        self.pictureCollection?.register(GBHPhotoCollectionViewCell.self,
                                         forCellWithReuseIdentifier: reuseIdentifier)
        self.pictureCollection?.delegate = self
        self.pictureCollection?.dataSource = self
        self.pictureCollection?.allowsMultipleSelection = true
        self.pictureCollection?.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor ?? .white
        self.pictureCollection?.translatesAutoresizingMaskIntoConstraints = false
        if let collection = self.pictureCollection {
            self.view.addSubview(collection)
            self.prepareCollectionViewConstraint()
        }

        // Define cell size 
        if let collectionWidth = self.pictureCollection?.frame.width {
            self.cellSize = (collectionWidth - (self.cellSpacing * (self.cellPerRow + 1.0))) / self.cellPerRow
        }
    }

    /// Set the collection view constraint 
    fileprivate func prepareCollectionViewConstraint() {
        // Top constraint
        if let collection = self.pictureCollection {
            // Top constraint 
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
        self.indicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: 40,
                                                              height: 40) )
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
                    GBHFacebookManager.shared.fbAlbumsPictureRequest(after: nil, album: album)
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
        // Update UI 
        self.stopLoading()

        // Update flag 
        self.alreadyLoaded = true

        // Set album's picture 
        if let album = sender.object as? GBHFacebookAlbum,
            self.album?.albumId == album.albumId {
            self.imageArray = album.photos
        }
    }

    @objc func actionSelectBarButton(sender: UIBarButtonItem) {
        // Clean collection and start loading
        self.cleanController()

        // Send to album delegate for download
        self.albumPictureDelegate?.didSelecPicturesInAlbum(imageModels: self.selectedImages)
    }

    fileprivate func cleanController() {
        // Clean collection and start loading
        self.alreadyLoaded = false
        self.imageArray = []
        self.startLoading()
    }
}

extension GBHPhotoPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDelegate & UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if imageArray.count <= 0, self.alreadyLoaded {
            // No picture in this album, add empty placeholder 
            // Should happen only for tagged album, when we can't have the album's picture count 
            let emptyLabel = UILabel(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: self.pictureCollection?.frame.size.width ?? 0,
                                                   height: self.pictureCollection?.frame.size.height ?? 0))
            emptyLabel.textAlignment = .center
            emptyLabel.text = "No picture(s) in this album."
            emptyLabel.font = UIFont.italicSystemFont(ofSize: 16)
            emptyLabel.textColor = UIColor.lightGray
            self.pictureCollection?.backgroundView = emptyLabel
            return 0
        }

        // Display photos 
        self.pictureCollection?.backgroundView = nil
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // Retrieve the selected image
        let imageModel = self.imageArray[indexPath.row]

        if GBHFacebookImagePicker.pickerConfig.allowMultipleSelection {
            // Multiple selection mode 
            self.selectedImages.append(imageModel)
        } else {
            // Clean collection and start loading
            self.cleanController()

            // Single selection mode  
            // Send to album delegate for download
            self.albumPictureDelegate?.didSelecPicturesInAlbum(imageModels: [imageModel])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Remove selected image
        let imageModel = self.imageArray[indexPath.row]
        if let index = self.selectedImages.index(where: { $0.imageId == imageModel.imageId }) {
            self.selectedImages.remove(at: index)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? GBHPhotoCollectionViewCell
        if cell == nil {
            cell = GBHPhotoCollectionViewCell()
        }

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        if let cell = cell as? GBHPhotoCollectionViewCell {
            // Configure cell with image
            cell.configure(picture: self.imageArray[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures == nil
            || self.selectedImages.count != (GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures ?? 1)
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
        return self.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.cellSpacing,
                            left: self.cellSpacing,
                            bottom: self.cellSpacing,
                            right: self.cellSpacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize ?? 0,
                      height: self.cellSize ?? 0)
    }
}
