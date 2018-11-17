//
//  ContentStateViewController.swift
//  SkyBreathe
//
//  Created by Florian Gabach on 25/10/2018.
//  Copyright © 2018 OpenAirlines. All rights reserved.
//

import UIKit

final class ContentStateViewController: UIViewController {

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

private extension ContentStateViewController {
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed:
            return MessageViewController()
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
