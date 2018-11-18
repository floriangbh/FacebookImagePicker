//
//  FacebookAlbumListController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

final class FacebookAlbumListController: UITableViewController {
    
    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return FacebookImagePicker.pickerConfig.uiConfig.statusbarStyle
    }
    
    // MARK: - Var
    
    weak var delegate: FacebookImagePickerDelegate?

    private let reuseIdentifier = "AlbumCell"

    fileprivate var albums: [FacebookAlbum]
    
    // MARK: - Lifecycle
    
    init(albums: [FacebookAlbum]) {
        self.albums = albums
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = FacebookImagePicker.pickerConfig.textConfig.localizedTitle
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        
        self.prepareTableView()
    }
    
    // MARK: - Prepare
    
    /// Init tableView dataSource, delegate, bar button & title
    fileprivate func prepareTableView() {
        // Common init
        self.tableView.tableFooterView = UIView()
        self.tableView.register(AlbumTableViewCell.self,
                                forCellReuseIdentifier: self.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    
    /// Handler for did retrieve album list
    @objc func didReceiveAlbum(_ sender: Notification) {
        if let albums =  sender.object as? [FacebookAlbum] {
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
                                                 for: indexPath) as? AlbumTableViewCell
        
        if cell == nil {
            cell = AlbumTableViewCell(style: .subtitle,
                                         reuseIdentifier: self.reuseIdentifier)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? AlbumTableViewCell {
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
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}
