//
//  FacebookAlbumController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import UIKit

class FacebookAlbumController: UIViewController {

    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return GBHFacebookImagePicker.pickerConfig.uiConfig.statusbarStyle
    }

    // MARK: - Var
    
    fileprivate lazy var stateViewController = ContentStateViewController()

    /// The image picker delegate
    weak var delegate: GBHFacebookImagePickerDelegate?

    /// Album cell identifier
    private let reuseIdentifier = "AlbumCell"

    /// Array which contains all the album of the facebook account
    fileprivate var albums: [GBHFacebookAlbum] = []

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.add(stateViewController)
        self.prepareObserver()
        self.doFacebookLogin()
    }

    // MARK: - Prepare

    /// Prepare observe for album retrieve & picture retrieve
    fileprivate func prepareObserver() {
        // Add observe for end album loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveAlbum),
                                               name: Notification.Name.ImagePickerDidRetrieveAlbum,
                                               object: nil)
    }

    // MARK: - Action

    /// Start Facebook login
    fileprivate func doFacebookLogin() {
        FacebookController.shared.login(controller: self) { (success, error) in
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
            }
        }
    }

    /// Handler for click on close button
    @objc fileprivate func closePicker() {
        self.delegate?.facebookImagePicker(didCancelled: self)
        self.dismissPicker()
    }

    /// Handler for did retrieve album list
    @objc func didReceiveAlbum(_ sender: Notification) {
        if let albums =  sender.object as? [GBHFacebookAlbum] {
            self.albums = albums
        }
    }

    /// Show popup with ask user_photos permission
    fileprivate func showDeniedPermissionPopup() {
        let alertController = UIAlertController(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedOups,
                                                message: GBHFacebookImagePicker.pickerConfig.textConfig.localizedAllowPhotoPermission,
                                                preferredStyle: UIAlertController.Style.alert)

        // Done & Cancel button
        let autorizeAction = UIAlertAction(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedAllow,
                                           style: UIAlertAction.Style.default,
                                           handler: { _ -> Void in
                                            self.doFacebookLogin()
        })

        // Cancel action
        let cancelAction = UIAlertAction(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedClose,
                                         style: UIAlertAction.Style.cancel,
                                         handler: { (_: UIAlertAction!) -> Void in
                                            self.dismissPicker()
        })

        // Add button & show
        alertController.addAction(autorizeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    /// Dismiss the picker
    func dismissPicker() {
        DispatchQueue.main.async {
            // Reset flag
            FacebookController.shared.reset()

            // Dismiss and call delegate
            self.dismiss(animated: true, completion: {
                self.delegate?.facebookImagePickerDismissed()
            })
        }
    }
}

extension FacebookAlbumController: FacebookAlbumPickerDelegate {

    // MARK: - FacebookAlbumPickerDelegate

    /// Did selected picture delegate
    ///
    /// - parameter imageModels: model of the selected pictures
    func didSelecPicturesInAlbum(imageModels: [GBHFacebookImage]) {

        var successModels = [GBHFacebookImage]()
        var errorModels = [GBHFacebookImage]()
        var errors = [Error?]()

        let downloadGroup = DispatchGroup()

        for imageModel in imageModels {
            downloadGroup.enter()

            // Download the image from the full size url
            imageModel.download(completion: { (error) in
                if error != nil {
                    // Error case
                    errors.append(error)
                    errorModels.append(imageModel)
                } else {
                    // Success case
                    successModels.append(imageModel)
                }

                downloadGroup.leave()
            })
        }

        downloadGroup.notify(queue: .main) {
            // Call success delegate
            self.delegate?.facebookImagePicker(
                imagePicker: self,
                successImageModels: successModels,
                errorImageModels: errorModels,
                errors: errors
            )

            // Dismiss picker
            self.dismissPicker()
        }
    }

    /// Performed when an error occured
    ///
    /// - Parameter error: the happened error
    func didFailSelectPictureInAlbum(error: Error?) {
        if let err = error {
            print(err.localizedDescription)
        }
    }
}
