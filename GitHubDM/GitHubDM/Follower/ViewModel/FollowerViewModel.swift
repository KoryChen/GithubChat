//
//  FollowerViewModel.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

protocol FollowerViewModelDelegate: class {
    func didFailToFetchFollower(viewModel: FollowerViewModel, error: Error)
    func didSucceedToFetchFollower(viewModel: FollowerViewModel)
}

class FollowerViewModel {
    let httpClient: HTTPClient
    weak var delegate: FollowerViewModelDelegate?
    private(set) var followers: [Follower] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func follower(at indexPath: IndexPath) -> Follower? {
        guard indexPath.row < followers.count else {
            return nil
        }
        return followers[indexPath.row]
    }
    
    func fetchFollowers() {
        if !FollowerCenter.shared.followers.isEmpty {
            followers = FollowerCenter.shared.followers
            self.delegate?.didSucceedToFetchFollower(viewModel: self)
            return
        }
        
        let request = FollowersRequest()
        httpClient.runTask(with: request) { [unowned self] (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    self.followers = response
                    FollowerCenter.shared.updateFollower(items: response)
                    self.delegate?.didSucceedToFetchFollower(viewModel: self)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailToFetchFollower(viewModel: self, error: error)
                }
            }
        }.resume()
    }
}
