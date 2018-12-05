//
//  MessageViewController.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 17/11/2018.
//

import UIKit

final class MessageViewController: UIViewController {
    
    // MARK: - Var
    
    fileprivate lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        return infoLabel
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        
        self.view.addSubview(self.infoLabel)
        self.infoLabel.pinCenter(to: self.view)
    }
}
