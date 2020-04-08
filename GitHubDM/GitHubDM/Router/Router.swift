//
//  Router.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class Router {
    let root: UINavigationController
    
    init() {
        let viewModel = FollowerViewModel(httpClient: HTTPClient())
        let followerVC = FollowerViewController(viewModel: viewModel)
        self.root = UINavigationController(rootViewController: followerVC)
        
        followerVC.delegate = self
    }
}

extension Router: FollowerViewControllerDelegate {
    func didSelectFollower(viewController: FollowerViewController, follower: Follower) {
        let viewModel = ChatViewModel(follower: follower)
        let chatVC = ChatViewController(viewModel: viewModel)
        root.pushViewController(chatVC, animated: true)
    }
}
