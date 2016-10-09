//
//  GBHPhotoPickerCollectionViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 29/09/2016.
//  Copyright (c) 2016 Florian Gabach <contact@floriangabach.fr>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class GBHPhotoPickerCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: Var
    fileprivate var indicator = UIActivityIndicatorView()
    fileprivate let reuseIdentifier = "Cell"
    fileprivate var pictureCollection: UICollectionView? // Collection for display album's pictures
    var albumPictureDelegate: GBHAlbumPickerTableViewControllerDelegate?
    fileprivate var imageArray: [GBHFacebookImageModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pictureCollection?.reloadData()
            }
        }
    }
    var album: GBHFacebookAlbumModel! // Curent album
    
    // MARK: Init & Load

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Prepare view
        self.prepareViewController()
        self.prepareObserver()
        
        // Fetch photos if empty
        self.getPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Prepare
    
    fileprivate func prepareObserver() {
        // Orbserve end of picture loading
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceivePicture(_:)),
                                               name: Notification.Name.GBHFacebookImagePickerDidRetriveAlbumPicture,
                                               object: nil)
        
    }
    
    fileprivate func prepareViewController() {
        self.title = self.album.name ?? NSLocalizedString("Pictures", comment: "")
        self.view.backgroundColor = GBHAppearanceManager.whiteCustom
        
        self.prepareCollectionView()
        self.prepareActivityIndicator()
        self.startLoading()
    }
    
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.pictureCollection?.register(GBHPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.pictureCollection?.delegate = self
        self.pictureCollection?.dataSource = self
        self.view.addSubview(self.pictureCollection!)
        self.pictureCollection?.backgroundColor = UIColor.white
    }
    
    // MARK: - Loading indicator
    
    fileprivate func prepareActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 40, height: 40) )
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.color = UIColor.black
    }
    
    fileprivate func stopLoading() {
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    // MARK: - Action
    
    /**
    * Start request for album's pictures
    **/
    fileprivate func getPhotos() {
        self.imageArray = self.album.photos
        if imageArray.isEmpty{
            self.startLoading()
            GBHFacebookHelper.shared.fbAlbumsPictureRequest(after: nil, album: album)
        } else {
            self.stopLoading()
        }
    }
    
    /**
     * Did finish get album's pictures callback
     **/
    @objc fileprivate func didReceivePicture(_ sender: Notification) {
        self.stopLoading()
        if let album = sender.object as? GBHFacebookAlbumModel, self.album?.id == album.id {
            self.imageArray = album.photos
        }
    }

    // MARK: UICollectionView

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Set sellection style
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = .none
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        // Set url to the delegate
        if let url = self.imageArray[indexPath.row].link {
            self.albumPictureDelegate?.didSelecPictureInAlbum(url: url)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GBHPhotoCollectionViewCell
        if cell == nil {
            cell = GBHPhotoCollectionViewCell()
        }
        
        cell?.configure(picture: self.imageArray[indexPath.row])
    
        return cell!
    }
}
