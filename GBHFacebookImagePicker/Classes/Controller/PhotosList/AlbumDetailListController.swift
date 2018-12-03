//
//  AlbumDetailListController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 21/11/2018.
//

import UIKit

final class AlbumDetailListController: UIViewController {
    
    /// MARK: Var
    
    fileprivate var cellSize: CGFloat?
    
    fileprivate let cellPerRow: CGFloat = FacebookImagePicker.pickerConfig.picturePerRow

    fileprivate let cellSpacing: CGFloat = FacebookImagePicker.pickerConfig.cellSpacing
    
    fileprivate var imageArray: [FacebookImage]
    
    fileprivate var pictureCollection: UICollectionView?
    
    weak var delegate: AlbumDetailDelegate?
    
    // MARK: - Lifecycle
    
    init(images: [FacebookImage]) {
        self.imageArray = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViewController()
        self.prepareCollectionView()
    }
    
    // MARK: Prepare
    
    fileprivate func prepareViewController() {
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
    }
    
    fileprivate func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        guard let collectionView = self.pictureCollection else { return }
        collectionView.register(cellType: PhotoCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.view.addSubview(collectionView)
        self.view.pinEdges(to: collectionView)
        self.cellSize = (collectionView.frame.width - (self.cellSpacing * (self.cellPerRow + 1.0))) / self.cellPerRow
    }
    
    // MARK: Action
    
    internal func selectAllCell() {
        self.pictureCollection?.selectAllCell()
    }
}

extension AlbumDetailListController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate & UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageModel = self.imageArray.get(at: indexPath.row) else { return }
        self.delegate?.didSelectImage(image: imageModel)
        
        if FacebookImagePicker.pickerConfig.performTapAnimation,
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.tapAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let imageModel = self.imageArray.get(at: indexPath.row) else { return }
        self.delegate?.didDeselectImage(image: imageModel)

        if FacebookImagePicker.pickerConfig.performTapAnimation,
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.tapAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        cell.configure(picture: self.imageArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return delegate?.shouldSelectImage() ?? false
    }
    
}

extension AlbumDetailListController: UICollectionViewDelegateFlowLayout {
    
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
        return UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize ?? 0, height: self.cellSize ?? 0)
    }
}
