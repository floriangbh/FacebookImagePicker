//
//  FacebookAlbumListController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

final class FacebookAlbumListController: UITableViewController {
    
    // MARK: - Var
    
    weak var delegate: FacebookAlbumPickerDelegate?

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
        
        self.prepareController()
        self.prepareTableView()
    }
    
    // MARK: - Prepare
    
    fileprivate func prepareController() {
        self.title = FacebookImagePicker.pickerConfig.textConfig.localizedTitle
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
    }
    
    fileprivate func prepareTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(cellType: AlbumTableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    
    // MARK: - Table view data source
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return self.albums.count == 0 ? 0 : 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AlbumTableViewCell else { return }
        cell.configure(album: albums[indexPath.row])
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = self.albums.get(at: indexPath.row) else { return }
        self.delegate?.didSelectAlbum(album: album)
    }
}
