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
    
    weak var delegate: FacebookAlbumDetailPickerDelegate?
    
    var album: FacebookAlbum?
    
    public var selectedImages = [FacebookImage]() {
        didSet {
            let count = self.selectedImages.count
            self.selectBarButton.isEnabled = count > 0
            
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
    
    fileprivate var albumDetailListController: AlbumDetailListController?
    
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
    
    // MARK: Prepare
    
    fileprivate func prepareViewController() {
        self.title = self.album?.name ?? FacebookImagePicker.pickerConfig.textConfig.localizedPictures
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.prepareMultipleSelectionButton()
    }
    
    fileprivate func prepareMultipleSelectionButton() {
        var items: [UIBarButtonItem] = [UIBarButtonItem.flexibleSpaceItem()]
        
        if FacebookImagePicker.pickerConfig.maximumSelectedPictures > 1 {
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
    
    fileprivate func getPhotos() {
        guard let currentAlbum = self.album else {
            print("Failed to go the album reference")
            return
        }
        
        let currentAlbumPhotos = currentAlbum.photos
        if currentAlbumPhotos.isEmpty {
            FacebookController.shared.fbAlbumsPictureRequest(album: currentAlbum) { result in
                switch result {
                case .success(let completeAlbum):
                    self.album = completeAlbum
                    if completeAlbum.photos.isEmpty {
                        self.renderEmptyAlbum()
                    } else {
                        self.render(completeAlbum.photos)
                    }
                case .failure(let error):
                    // TODO: Error handling 
                    print(error.localizedDescription)
                }
            }
        } else {
            self.render(currentAlbumPhotos)
        }
    }
    
    @objc func actionSelectBarButton(sender: UIBarButtonItem) {
        self.delegate?.didSelectImages(images: selectedImages)
    }
    
    @objc func didSelectAllPicture(sender: UIBarButtonItem) {
        self.albumDetailListController?.selectAllCell()
        self.selectedImages = self.album?.photos.map {$0} ?? []
    }
    
    // MARK: - Render
    
    fileprivate func renderEmptyAlbum() {
        let message = FacebookImagePicker.pickerConfig.textConfig.localizedNoPicturesInAlbum
        let emptyAlbumController = MessageViewController(message: message)
        self.stateViewController.transition(to: .render(emptyAlbumController))
    }
    
    fileprivate func render(_ photos: [FacebookImage]) {
        self.navigationController?.setToolbarHidden(!shouldDisplayToolbar, animated: true)
        
        self.albumDetailListController = AlbumDetailListController(images: photos)
        guard let albumDetailListController = self.albumDetailListController else { return }
        albumDetailListController.delegate = self
        self.stateViewController.transition(to: .render(albumDetailListController))
    }
}

extension AlbumDetailController: AlbumDetailDelegate {
    func didSelectImage(image: FacebookImage) {
        self.selectedImages.append(image)
        
        if FacebookImagePicker.pickerConfig.maximumSelectedPictures == 1 {
            self.delegate?.didSelectImages(images: selectedImages)
        }
    }
    
    func didDeselectImage(image: FacebookImage) {
        if let index = self.selectedImages.firstIndex(where: { $0.imageId == image.imageId }) {
            self.selectedImages.remove(at: index)
        }
    }
    
    func shouldSelectImage() -> Bool {
        return self.selectedImages.count != FacebookImagePicker.pickerConfig.maximumSelectedPictures
    }
}
