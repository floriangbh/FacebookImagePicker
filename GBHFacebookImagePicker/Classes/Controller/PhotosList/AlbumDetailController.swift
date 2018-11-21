//
//  AlbumDetailController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 21/11/2018.
//

import UIKit

final class AlbumDetailController: UIViewController {
    
    /// MARK: Var
    
    fileprivate var shouldDisplayToolbar: Bool {
        return (self.album?.photos.count ?? 0 > 0) && FacebookImagePicker.pickerConfig.shouldDisplayToolbar
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
    
    var facebookController: FacebookController
    
    fileprivate lazy var stateViewController = ContentStateViewController()
    
    // MARK: - Lifecycle
    
    init(facebookController: FacebookController) {
        self.facebookController = facebookController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(stateViewController)
        
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
        self.prepareObserver()
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

    // MARK: - Action
    
    /// Start request for album's pictures
    fileprivate func getPhotos() {
        guard let photosArray = self.album?.photos else { return }
            if photosArray.isEmpty {
                if let album = self.album {
                    FacebookController.shared.fbAlbumsPictureRequest(after: nil, album: album)
                } else {
                    //self.albumPictureDelegate?.didFailSelectPictureInAlbum(error: nil)
                }
            } else {
                self.navigationController?.setToolbarHidden(!shouldDisplayToolbar, animated: true)
            }
    }
    
    /// Did finish get album's pictures callback
    @objc fileprivate func didReceivePicture(_ sender: Notification) {
        // Set album's picture
        if let album = sender.object as? FacebookAlbum,
            self.album?.albumId == album.albumId {
            
            self.render(album.photos)
            
            self.navigationController?.setToolbarHidden(!shouldDisplayToolbar,
                                                        animated: true)
        }
    }
    
    private func render(_ photos: [FacebookImage]) {
        let albumDetailListController = AlbumDetailListController(images: photos)
        albumDetailListController.delegate = self
        self.stateViewController.transition(to: .render(albumDetailListController))
    }
    
    @objc func actionSelectBarButton(sender: UIBarButtonItem) {
        // Clean collection and start loading
        self.cleanController()
        
        // Send to album delegate for download
        //self.albumPictureDelegate?.didSelecPicturesInAlbum(imageModels: self.selectedImages)
    }
    
    @objc func didSelectAllPicture(sender: UIBarButtonItem) {
//        self.pictureCollection?.selectAllCell()
//        self.selectedImages = self.imageArray.map {$0}
    }
    
    fileprivate func cleanController() {
        //
    }
}

extension AlbumDetailController: AlbumDetailDelegate {
    func didSelectImage(image: FacebookAlbum) {
        //
    }
    
    func shouldSelectImage() -> Bool {
        return FacebookImagePicker.pickerConfig.maximumSelectedPictures == nil
            || self.selectedImages.count != (FacebookImagePicker.pickerConfig.maximumSelectedPictures ?? 1)
    }
}
