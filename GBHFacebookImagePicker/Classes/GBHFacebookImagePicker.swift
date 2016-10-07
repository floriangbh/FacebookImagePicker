//
//  GBHAlbumPickerTableViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright © 2016 Florian Gabach. All rights reserved.
//

import UIKit

protocol GBHAlbumPickerTableViewControllerDelegate {
    func didSelecPictureInAlbum(url: String)
}

public class GBHFacebookImagePicker: UITableViewController, GBHAlbumPickerTableViewControllerDelegate {
    
    // MARK: - Var
    public var delegate: GBHFacebookImagePickerDelegate!
    fileprivate var indicator = UIActivityIndicatorView() // Loading indicator
    fileprivate var albums: [GBHFacebookAlbumModel] = [] { // Albums list
        didSet {
            // Reload table data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Init
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare view
        self.prepareTableView()
        self.prepareObserver()
        self.prepareActivityIndicator()
        
        // Start Facebook login
        self.doFacebookLogin()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Prepare
    
    /**
     * Init tableView dataSource, delegate, bar button & title
     **/
    fileprivate func prepareTableView() {
        // Common init
        self.tableView.tableFooterView = UIView()
        self.title = NSLocalizedString("Album", comment: "")
        self.tableView.register(GBHAlbumTableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = GBHAppearanceManager.whiteCustom
        
        // Close button (on the right corner of navigation bar)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closePicker))
        closeButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    /**
     * Prepare observe for album retrieve & picture retrieve
     **/
    fileprivate func prepareObserver() {
        // Add observe for end album loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveAlbum),
                                               name: Notification.Name.GBHFacebookImagePickerDidRetrieveAlbum,
                                               object: nil)
    }
    
    // MARK: - Loading indicator
    
    /**
     * Create & add activity indicator to the center of view
     **/
    fileprivate func prepareActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 40, height: 40) )
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        self.startLoading()
    }
    
    /**
     * Start loading indicator
     **/
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.color = UIColor.black
    }
    
    /**
     * Stop & hide loading indicator
     **/
    fileprivate func stopLoading() {
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    // MARK: - Action
    
    /**
     *
     **/
    fileprivate func doFacebookLogin() {
        GBHFacebookHelper.shared.login(vc: self) { (success, error) in
            if !success {
                // Something wrong
                if let loginError = error {
                    switch loginError {
                    case .LoginCancelled:
                        // Cancelled login
                        self.delegate.facebookImagePicker(didCancelled: self)
                        self.dismiss(animated: true, completion: nil)
                    case .LoginFailed:
                        // Failed to login with Facebook
                        self.delegate.facebookImagePicker(imagePicker: self, didFailWithError: error)
                        self.dismiss(animated: true, completion: nil)
                    case .PermissionDenied:
                        // "user_photos" permission are denied, we need to ask permission !
                        self.showDeniedPermissionPopup()
                    }
                }
            }
        }
    }
    
    /**
     * Handler for click on close button
     **/
    @objc fileprivate func closePicker() {
        self.delegate.facebookImagePicker(didCancelled: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * Handler for did retrieve album list
     **/
    func didReceiveAlbum(_ sender: Notification) {
        if let albums =  sender.object as? [GBHFacebookAlbumModel] {
            self.albums = albums
            self.stopLoading()
        }
    }
    
    /**
     * Show popup with ask user_photos permission
     **/
    fileprivate func showDeniedPermissionPopup() {
        let alertController = UIAlertController(title: NSLocalizedString("Oups", comment: ""),
                                                message: NSLocalizedString("You need to allow photo's permission.", comment: ""),
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // Done & Cancel button
        let autorizeAction = UIAlertAction(title: NSLocalizedString("Allow", comment: ""),
                                           style: UIAlertActionStyle.default,
                                           handler: {
                                            alert -> Void in
                                            self.doFacebookLogin()
        })
        
        // Cancel action
        let cancelAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""),
                                         style: UIAlertActionStyle.cancel,
                                         handler: {
                                            (action : UIAlertAction!) -> Void in
                                            self.dismiss(animated: true, completion: nil)
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
        let cellIdentifier = "AlbumCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GBHAlbumTableViewCell
        if cell == nil {
            cell = GBHAlbumTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = albums[indexPath.row].name
        if let count = albums[indexPath.row].count {
            cell?.detailTextLabel?.text = "\(count)"
        }
        
        if let url = albums[indexPath.row].coverUrl {
            cell?.photoImageView.imageUrl = url
        }
        
        return cell!
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailVC = GBHPhotoPickerCollectionViewController()
        albumDetailVC.albumPictureDelegate = self
        albumDetailVC.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(albumDetailVC,
                                                      animated: true)
    }
    
    func didSelecPictureInAlbum(url: String) {
        self.delegate.facebookImagePicker(imagePicker: self, didSelectImageWithUrl: url)
    }
}
