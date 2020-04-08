//
//  FollowerCenter.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class FollowerCenter: DataCenter {
    typealias DataType = Set<Follower>
    var fileKey: String = "FollowerCenterData.dat"
    private let queue =
    DispatchQueue(
      label: "follower.concurrent",
      attributes: .concurrent)
    private var followerRepo: DataType = []
    
    private init() {
        do {
            followerRepo = try (self.load() ?? [])
        } catch {
            followerRepo = []
            //TODO: handle Error
        }
    }
    
    var followers: [Follower] {
        var copyFollowers: [Follower]!
        queue.sync {
            copyFollowers = self.followerRepo.sorted(by: <)
        }
        return copyFollowers
    }
    
    static let shared = FollowerCenter()
    
    func updateFollower(items: [Follower]) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.followerRepo.formUnion(Set(items))
            self.save(data: self.followerRepo)
        }
    }
}
