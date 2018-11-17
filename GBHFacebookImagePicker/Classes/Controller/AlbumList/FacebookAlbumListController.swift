//
//  FacebookAlbumListController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

class FacebookAlbumListController: UITableViewController {
    
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
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.prepareTableView()
        self.prepareObserver()
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
        let albumDetailVC = PhotoPickerViewController()
        //albumDetailVC.albumPictureDelegate = self
        albumDetailVC.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(albumDetailVC,
                                                      animated: true)
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
