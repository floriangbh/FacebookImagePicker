//
//  PhotoPickerViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

final class PhotoPickerViewController: UIViewController {

    /// MARK: Var

    /// Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return FacebookImagePicker.pickerConfig.uiConfig.statusbarStyle
    }

    /// Cell identifier 
    fileprivate let reuseIdentifier = "Cell"

    /// Cell size 
    fileprivate var cellSize: CGFloat?

    /// Number of cell for each row 
    fileprivate let cellPerRow: CGFloat = FacebookImagePicker.pickerConfig.picturePerRow

    /// Spacing beetween cell 
    fileprivate let cellSpacing: CGFloat = FacebookImagePicker.pickerConfig.cellSpacing

    fileprivate var shouldDisplayToolbar: Bool {
        return (self.album?.photos.count ?? 0 > 0) && FacebookImagePicker.pickerConfig.shouldDisplayToolbar
    }

    /// Array which contain image model of pictures which are in the album
    fileprivate var imageArray: [FacebookImage] = [] {
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
    weak var albumPictureDelegate: FacebookAlbumPickerDelegate?

    // Current album model 
    var album: FacebookAlbum? // Curent album

    //
    public var selectedImages = [FacebookImage]() {
        didSet {
            // How many image selected
            let count = self.selectedImages.count

            // Manage disable/enable state
            self.selectBarButton.isEnabled = count > 0

            // Update button title
            var text = FacebookImagePicker.pickerConfig.textConfig.localizedSelect

            if count > 0 {
                text.append(" (\(count.locallyFormattedString()))")
            }

            self.selectBarButton.title = text
        }
    }

    fileprivate lazy var selectBarButton: UIBarButtonItem = {
        let selectBarButton = UIBarButtonItem(
            title: FacebookImagePicker.pickerConfig.textConfig.localizedSelect,
            style: .plain,
            target: self,
            action: #selector(actionSelectBarButton(sender:))
        )
        selectBarButton.isEnabled = false
        return selectBarButton
    }()

    fileprivate lazy var selectAllBarButton: UIBarButtonItem = {
        let selectAllBarButton = UIBarButtonItem(
            title: FacebookImagePicker.pickerConfig.textConfig.localizedSelectAll,
            style: .plain,
            target: self,
            action: #selector(didSelectAllPicture(sender:))
        )
        return selectAllBarButton
    }()

    fileprivate lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.pictureCollection?.frame.size.width ?? 0.0,
                                               height: self.pictureCollection?.frame.size.height ?? 0.0))
        emptyLabel.textAlignment = .center
        emptyLabel.text = FacebookImagePicker.pickerConfig.textConfig.localizedNoPicturesInAlbum
        emptyLabel.font = UIFont.italicSystemFont(ofSize: 16)
        emptyLabel.textColor = UIColor.lightGray
        return emptyLabel
    }()

    fileprivate lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                               y: 0,
                                                               width: 40,
                                                               height: 40) )
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.backgroundColor = UIColor.clear
        indicator.color = UIColor.black
        return indicator
    }()

    /// The collection view where are display the pictures
    fileprivate var pictureCollection: UICollectionView? // Collection for display album's pictures

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewController()
        self.getPhotos()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setToolbarHidden(!shouldDisplayToolbar, animated: false)
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
        self.title = self.album?.name ?? FacebookImagePicker.pickerConfig.textConfig.localizedPictures
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor

        self.prepareMultipleSelectionButton()
        self.prepareCollectionView()
        self.prepareObserver()

        // Start loading 
        self.startLoading()
    }

    fileprivate func prepareMultipleSelectionButton() {
        var items: [UIBarButtonItem] = [UIBarButtonItem.flexibleSpaceItem()]

        if FacebookImagePicker.pickerConfig.allowMultipleSelection {
            items.append(selectBarButton)

            if FacebookImagePicker.pickerConfig.allowAllSelection {
                items.insert(selectAllBarButton, at: 0)
            }
        }

        if items.count > 1 {
            self.toolbarItems = items
            self.navigationController?.setToolbarHidden(!shouldDisplayToolbar, animated: false)
        }
    }

    /// Prepare pictureCollection which will contains album's pictures
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds,
                                                  collectionViewLayout: layout)
        self.pictureCollection?.register(PhotoCollectionViewCell.self,
                                         forCellWithReuseIdentifier: reuseIdentifier)
        self.pictureCollection?.delegate = self
        self.pictureCollection?.dataSource = self
        self.pictureCollection?.allowsMultipleSelection = true
        self.pictureCollection?.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor ?? .white
        if let collection = self.pictureCollection {
            self.view.addSubview(collection)
            self.view.pinEdges(to: collection)
        }

        // Define cell size
        if let collectionWidth = self.pictureCollection?.frame.width {
            self.cellSize = (collectionWidth - (self.cellSpacing * (self.cellPerRow + 1.0))) / self.cellPerRow
        }
    }

    // MARK: - Loading indicator

    fileprivate func startLoading() {
        self.loadingIndicator.startAnimating()
    }

    fileprivate func stopLoading() {
        self.loadingIndicator.stopAnimating()
    }

    // MARK: - Action

    /// Start request for album's pictures
    fileprivate func getPhotos() {
        if let photosArray = self.album?.photos {
            self.imageArray = photosArray
            if imageArray.isEmpty {
                self.startLoading()
                if let album = self.album {
                    FacebookController.shared.fbAlbumsPictureRequest(after: nil, album: album)
                } else {
                    self.albumPictureDelegate?.didFailSelectPictureInAlbum(error: nil)
                }
            } else {
                self.navigationController?.setToolbarHidden(!shouldDisplayToolbar,
                                                            animated: true)
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
        if let album = sender.object as? FacebookAlbum,
            self.album?.albumId == album.albumId {
            self.imageArray = album.photos
            self.navigationController?.setToolbarHidden(!shouldDisplayToolbar,
                                                        animated: true)
        }
    }

    @objc func actionSelectBarButton(sender: UIBarButtonItem) {
        // Clean collection and start loading
        self.cleanController()

        // Send to album delegate for download
        self.albumPictureDelegate?.didSelecPicturesInAlbum(imageModels: self.selectedImages)
    }

    @objc func didSelectAllPicture(sender: UIBarButtonItem) {
        self.pictureCollection?.selectAllCell()
        self.selectedImages = self.imageArray.map {$0}
    }

    fileprivate func cleanController() {
        // Clean collection and start loading
        self.alreadyLoaded = false
        self.imageArray = []
        self.startLoading()
    }
}

extension PhotoPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDelegate & UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if imageArray.count <= 0, self.alreadyLoaded {
            // No picture in this album, add empty placeholder 
            // Should happen only for tagged album, when we can't have the album's picture count
            self.pictureCollection?.backgroundView = emptyLabel
            return 0
        }

        if alreadyLoaded == false {
            // Display loader
            self.pictureCollection?.backgroundView = self.loadingIndicator
        } else {
            // Display photos
            self.pictureCollection?.backgroundView = nil
        }

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

        if FacebookImagePicker.pickerConfig.allowMultipleSelection {
            // Multiple selection mode 
            self.selectedImages.append(imageModel)
        } else {
            // Clean collection and start loading
            self.cleanController()

            // Single selection mode  
            // Send to album delegate for download
            self.albumPictureDelegate?.didSelecPicturesInAlbum(imageModels: [imageModel])
        }

        if FacebookImagePicker.pickerConfig.performTapAnimation,
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.tapAnimation()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Remove selected image
        let imageModel = self.imageArray[indexPath.row]
        if let index = self.selectedImages.index(where: { $0.imageId == imageModel.imageId }) {
            self.selectedImages.remove(at: index)
        }

        if FacebookImagePicker.pickerConfig.performTapAnimation,
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.tapAnimation()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? PhotoCollectionViewCell
        if cell == nil {
            cell = PhotoCollectionViewCell()
        }
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        if let cell = cell as? PhotoCollectionViewCell {
            // Configure cell with image
            cell.configure(picture: self.imageArray[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return FacebookImagePicker.pickerConfig.maximumSelectedPictures == nil
            || self.selectedImages.count != (FacebookImagePicker.pickerConfig.maximumSelectedPictures ?? 1)
    }

}

extension PhotoPickerViewController: UICollectionViewDelegateFlowLayout {

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
