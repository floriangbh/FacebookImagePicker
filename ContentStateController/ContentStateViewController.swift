//
//  ContentStateViewController.swift
//  Bolts
//
//  Created by Florian Gabach on 14/11/2018.
//

import UIKit

class ContentStateViewController: UIViewController {

    // MARK: - Var

    fileprivate var state: State?

    fileprivate var shownViewController: UIViewController?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if state == nil {
            self.transition(to: .loading)
        }
    }

    // MARK: - Action

    func transition(to newState: State) {
        self.shownViewController?.remove()
        let viewCtrl = viewController(for: newState)
        self.add(viewCtrl)
        self.shownViewController = viewCtrl
        self.state = newState
    }
}

extension ContentStateViewController {
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed:
            return ErrorViewController()
        case .render(let viewController):
            return viewController
        }
    }
}

extension ContentStateViewController {
    public enum State {
        case loading
        case failed(Error)
        case render(UIViewController)
    }
}
