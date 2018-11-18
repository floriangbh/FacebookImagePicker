//
//  LoadingViewController.swift
//  OpenSourceControllerDemo
//
//  Created by Florian Gabach on 23/10/2018.
//  Copyright © 2018 OpenSourceController. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {

    // MARK: - Var

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.startAnimating()
        return activityIndicator
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

        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.pinCenter(to: self.view)
    }
}
