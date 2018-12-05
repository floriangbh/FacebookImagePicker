//
//  FacebookAlbumController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import UIKit

final class FacebookAlbumController: UIViewController {
    
    // MARK: - Var
    
    fileprivate lazy var stateViewController = ContentStateViewController()
    
    weak var delegate: FacebookImagePickerDelegate?
    
    fileprivate var facebookController: FacebookController
    
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
    
    fileprivate func prepareController() {
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.title = FacebookImagePicker.pickerConfig.textConfig.localizedTitle
    }
    
    fileprivate func prepareCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closePicker))
        closeButton.tintColor = FacebookImagePicker.pickerConfig.uiConfig.closeButtonColor ?? .black
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    // MARK: - Action
    
    /// Start Facebook login
    fileprivate func doFacebookLogin() {
        self.facebookController.login(controller: self) { (success, error) in
            if !success {
                // Something wrong
                if let loginError = error {
                    switch loginError {
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
            } else {
                self.getFacebookAlbums()
            }
        }
    }
    
    fileprivate func getFacebookAlbums() {
        self.facebookController.fetchFacebookAlbums(completion: { (albums) in
            self.render(albums)
        })
    }
    
    @objc fileprivate func closePicker() {
        self.delegate?.facebookImagePicker(didCancelled: self)
        self.dismissPicker()
    }
    
    fileprivate func showDeniedPermissionPopup() {
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
            
            imageModel.download(completion: { (error) in
                if error != nil {
                    errors.append(error)
                    errorModels.append(imageModel)
                } else {
                    successModels.append(imageModel)
                }
                
                downloadGroup.leave()
            })
        }
        
        downloadGroup.notify(queue: .main) {
            self.delegate?.facebookImagePicker(imagePicker: self, successImageModels: successModels, errorImageModels: errorModels,errors: errors)
            self.dismissPicker()
        }
    }
}
