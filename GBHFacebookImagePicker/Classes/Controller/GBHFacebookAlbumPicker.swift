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
    func didSelecPictureInAlbum(imageModel: GBHFacebookImage)

    /// Failed selecte picture in album
    ///
    /// - parameter error: error
    func didFailSelectPictureInAlbum(error: Error?)
}

class GBHFacebookAlbumPicker: UITableViewController {

    // MARK: - Var

    /// The image picker delegate 
    weak var delegate: GBHFacebookImagePickerDelegate?

    /// Album cell identifier 
    private let reuseIdentifier = "AlbumCell"

    /// Loading indicator 
    fileprivate var indicator = UIActivityIndicatorView() // Loading indicator

    /// Array which contains all the album of the facebook account
    fileprivate var albums: [GBHFacebookAlbum] = [] { // Albums list
        didSet {
            // Reload table data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Prepare view
        self.prepareTableView()
        self.prepareObserver()
        self.prepareActivityIndicator()

        // Start Facebook login
        self.doFacebookLogin()
    }

    // MARK: - Prepare

    /// Init tableView dataSource, delegate, bar button & title
    fileprivate func prepareTableView() {
        // Common init
        self.tableView.tableFooterView = UIView()
        self.title = NSLocalizedString("Album(s)", comment: "")
        self.tableView.register(GBHAlbumTableViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        self.view.backgroundColor = GBHFacebookImagePicker.pickerConfig.ui.backgroundColor

        // Close button (on the right corner of navigation bar)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closePicker))
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

    /// Create & add activity indicator to the center of view
    fileprivate func prepareActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 40, height: 40) )
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        self.startLoading()
    }

    /// Start loading indicator
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.color = UIColor.black
    }

    /// Stop & hide loading indicator
    fileprivate func stopLoading() {
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }

    // MARK: - Action

    /// Start Facebook login
    fileprivate func doFacebookLogin() {
        GBHFacebookHelper.shared.login(controller: self) { (success, error) in
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
    func didReceiveAlbum(_ sender: Notification) {
        if let albums =  sender.object as? [GBHFacebookAlbum] {
            self.albums = albums
            self.stopLoading()
        }
    }

    /// Show popup with ask user_photos permission
    fileprivate func showDeniedPermissionPopup() {
        let alertController = UIAlertController(title: NSLocalizedString("Oups",
                                                                         comment: ""),
                                                message: NSLocalizedString("You need to allow photo's permission.",
                                                                           comment: ""),
                                                preferredStyle: UIAlertControllerStyle.alert)

        // Done & Cancel button
        let autorizeAction = UIAlertAction(title: NSLocalizedString("Allow",
                                                                    comment: ""),
                                           style: UIAlertActionStyle.default,
                                           handler: { _ -> Void in
                                            self.doFacebookLogin()
        })

        // Cancel action
        let cancelAction = UIAlertAction(title: NSLocalizedString("Close",
                                                                  comment: ""),
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

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier,
                                                 for: indexPath) as? GBHAlbumTableViewCell
        if cell == nil {
            cell = GBHAlbumTableViewCell(style: .subtitle, reuseIdentifier: self.reuseIdentifier)
        }

        cell?.configure(album: albums[indexPath.row])

        return cell!
    }

    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    /// - parameter imageModel: model of the selected picture
    func didSelecPictureInAlbum(imageModel: GBHFacebookImage) {

        if let url = imageModel.fullSizeUrl,
            let imageUrl = URL(string: url) {
            // Start url loading
            URLSession.shared.dataTask(with: imageUrl as URL) { data, response, error in
                guard let data = data, error == nil else {
                    self.delegate?.facebookImagePicker(imagePicker: self, didFailWithError: error)
                    self.dismissPicker()
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    self.delegate?.facebookImagePicker(imagePicker: self, didFailWithError: error)
                    self.dismissPicker()
                    return
                }

                // Set the image
                imageModel.image = UIImage(data: data)

                self.delegate?.facebookImagePicker(imagePicker: self,
                                                   imageModel: imageModel)
                self.dismissPicker()
                }.resume()
        } else {
            self.delegate?.facebookImagePicker(imagePicker: self, didFailWithError: nil)
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
