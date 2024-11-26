//
//  FacebookAlbumController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import UIKit

final class FacebookAlbumController: UIViewController {
    
    // MARK: - Var
    
    private lazy var stateViewController = ContentStateViewController()
    
    weak var delegate: FacebookImagePickerDelegate?
    
    private var facebookController: FacebookController
    
    // MARK: - Lifecycle
    
    init(facebookController: FacebookController) {
        self.facebookController = facebookController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(stateViewController)
        
        self.prepareController()
        self.prepareCloseButton()
        
        self.doFacebookLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - Prepare
    
    private func prepareController() {
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.title = FacebookImagePicker.pickerConfig.textConfig.localizedTitle
    }
    
    private func prepareCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closePicker))
        closeButton.tintColor = FacebookImagePicker.pickerConfig.uiConfig.closeButtonColor
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    // MARK: - Action
    
    /// Start Facebook login
    private func doFacebookLogin() {
        self.facebookController.login(controller: self) { (result) in
            switch result {
            case .success:
                self.getFacebookAlbums()
            case .failure(let error):
                switch error {
                case .loginCancelled:
                    // Cancelled login
                    self.delegate?.facebookImagePicker(didCancelled: self)
                    self.dismissPicker()
                case .loginFailed:
                    // Failed to login with Facebook
                    self.delegate?.facebookImagePicker(imagePicker: self, didFailWithError: error)
                    self.dismissPicker()
                case .permissionDenied:
                    // "user_photos" permission are denied, we need to ask permission !
                    self.showDeniedPermissionPopup()
                }
            }
        }
    }
    
    private func getFacebookAlbums() {
        self.facebookController.fetchFacebookAlbums(completion: { (result) in
            switch result {
            case .success(let albums):
                self.render(albums)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func closePicker() {
        self.delegate?.facebookImagePicker(didCancelled: self)
        self.dismissPicker()
    }
    
    private func showDeniedPermissionPopup() {
        AlertController.showPermissionAlert(fromController: self,
                                            allowCompletionHandler: {
                                                self.doFacebookLogin()
        }, closeCompletionaHandler: {
            self.dismissPicker()
        })
    }
    
    // MARK: - Renders
    
    private func render(_ albums: [FacebookAlbum]) {
        let albumsListController = FacebookAlbumListController(albums: albums)
        albumsListController.delegate = self
        self.stateViewController.transition(to: .render(albumsListController))
    }
    
    // MARK: - Navigation

    func dismissPicker() {
        DispatchQueue.main.async {
            self.facebookController.reset()

            self.dismiss(animated: true, completion: {
                self.delegate?.facebookImagePickerDismissed()
            })
        }
    }
}

extension FacebookAlbumController: FacebookAlbumPickerDelegate {
    func didSelectAlbum(album: FacebookAlbum) {
        let albumController = AlbumDetailController(facebookController: self.facebookController)
        albumController.delegate = self
        albumController.album = album
        self.navigationController?.pushViewController(albumController, animated: true)
    }
}

extension FacebookAlbumController: FacebookAlbumDetailPickerDelegate {
    func didPressFinishSelection(images: [FacebookImage]) {
        //
    }
    
    func didSelectImages(images: [FacebookImage]) {
        var successModels = [FacebookImage]()
        var errorModels = [FacebookImage]()
        var errors = [Error?]()
        
        let downloadGroup = DispatchGroup()
        
        for imageModel in images {
            downloadGroup.enter()
            
            imageModel.download(completion: { (result) in
                switch result {
                case .success:
                    successModels.append(imageModel)
                case .failure(let error):
                    errors.append(error)
                    errorModels.append(imageModel)
                }
                
                downloadGroup.leave()
            })
        }
        
        downloadGroup.notify(queue: .main) {
            self.delegate?.facebookImagePicker(imagePicker: self,
                                               successImageModels: successModels,
                                               errorImageModels: errorModels,
                                               errors: errors)
            self.dismissPicker()
        }
    }
}
