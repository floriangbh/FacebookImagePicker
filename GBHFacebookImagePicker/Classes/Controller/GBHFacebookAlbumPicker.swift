//
//  GBHAlbumPickerTableViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>

import UIKit

protocol GBHAlbumPickerTableViewControllerDelegate: class {
    /// Perform when picture are selected in the displayed album
    ///
    /// - parameter imageModel: model of the selected picture
    func didSelecPicturesInAlbum(imageModels: [GBHFacebookImage])

    /// Failed to select picture in album
    ///
    /// - parameter error: error
    func didFailSelectPictureInAlbum(error: Error?)
}

class GBHFacebookAlbumPicker: UITableViewController {

    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return GBHFacebookImagePicker.pickerConfig.uiConfig.statusbarStyle
    }

    // MARK: - Var

    /// The image picker delegate 
    weak var delegate: GBHFacebookImagePickerDelegate?

    /// Album cell identifier 
    private let reuseIdentifier = "AlbumCell"

    /// Array which contains all the album of the facebook account
    fileprivate var albums: [GBHFacebookAlbum] = [] { // Albums list
        didSet {
            // Reload table data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    fileprivate lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: 40,
                                                              height: 40) )
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.backgroundColor = UIColor.clear
        indicator.color = UIColor.black
        return indicator
    }()

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Prepare view
        self.prepareTableView()
        self.prepareObserver()

        // Start Facebook login
        self.startLoading()
        self.doFacebookLogin()
    }

    // MARK: - Prepare

    /// Init tableView dataSource, delegate, bar button & title
    fileprivate func prepareTableView() {
        // Common init
        self.tableView.tableFooterView = UIView()
        self.title = GBHFacebookImagePicker.pickerConfig.textConfig.localizedTitle
        self.tableView.register(GBHAlbumTableViewCell.self,
                                forCellReuseIdentifier: self.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        self.view.backgroundColor = GBHFacebookImagePicker.pickerConfig.uiConfig.backgroundColor ?? .white
        self.tableView.backgroundView = self.loadingIndicator

        // Close button (on the right corner of navigation bar)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(self.closePicker))
        closeButton.tintColor = GBHFacebookImagePicker.pickerConfig.uiConfig.closeButtonColor ?? .black
        self.navigationItem.rightBarButtonItem = closeButton
    }

    /// Prepare observe for album retrieve & picture retrieve
    fileprivate func prepareObserver() {
        // Add observe for end album loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveAlbum),
                                               name: Notification.Name.ImagePickerDidRetrieveAlbum,
                                               object: nil)
    }

    // MARK: - Loading indicator

    fileprivate func startLoading() {
        self.loadingIndicator.startAnimating()
    }

    fileprivate func stopLoading() {
        self.loadingIndicator.stopAnimating()
    }

    // MARK: - Action

    /// Start Facebook login
    fileprivate func doFacebookLogin() {
        GBHFacebookManager.shared.login(controller: self) { (success, error) in
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
            self.stopLoading()
        }
    }

    /// Show popup with ask user_photos permission
    fileprivate func showDeniedPermissionPopup() {
        let alertController = UIAlertController(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedOups,
                                                message: GBHFacebookImagePicker.pickerConfig.textConfig.localizedAllowPhotoPermission,
                                                preferredStyle: UIAlertControllerStyle.alert)

        // Done & Cancel button
        let autorizeAction = UIAlertAction(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedAllow,
                                           style: UIAlertActionStyle.default,
                                           handler: { _ -> Void in
                                            self.doFacebookLogin()
        })

        // Cancel action
        let cancelAction = UIAlertAction(title: GBHFacebookImagePicker.pickerConfig.textConfig.localizedClose,
                                         style: UIAlertActionStyle.cancel,
                                         handler: { (_: UIAlertAction!) -> Void in
                                            self.dismissPicker()
        })

        // Add button & show
        alertController.addAction(autorizeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        if self.albums.count == 0 {
            return 0
        }

        return 1
    }

    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell 
        var cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier,
                                                 for: indexPath) as? GBHAlbumTableViewCell

        if cell == nil {
            cell = GBHAlbumTableViewCell(style: .subtitle,
                                         reuseIdentifier: self.reuseIdentifier)
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {

        if let cell = cell as? GBHAlbumTableViewCell {
            // Configure the cell 
            cell.configure(album: albums[indexPath.row])
        }
    }

    override public func tableView(_ tableView: UITableView,
                                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    /// When album are selected 
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailVC = GBHPhotoPickerViewController()
        albumDetailVC.albumPictureDelegate = self
        albumDetailVC.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(albumDetailVC,
                                                      animated: true)
    }

    // MARK: - Navigation 

    /// Dismiss the picker 
    func dismissPicker() {
        DispatchQueue.main.async {
            // Reset flag
            GBHFacebookManager.shared.reset()

            // Dismiss and call delegate 
            self.dismiss(animated: true, completion: {
                self.delegate?.facebookImagePickerDismissed()
            })
        }
    }
}

extension GBHFacebookAlbumPicker: GBHAlbumPickerTableViewControllerDelegate {

    // MARK: - GBHAlbumPickerTableViewControllerDelegate

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
