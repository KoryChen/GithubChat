//
//  Follower.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

struct Follower: Codable, Equatable {
    let identifier: Int
    let avatarURL: String?
    let userID: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case avatarURL = "avatar_url"
        case userID = "login"
    }
    
    static func <(lhs: Follower, rhs: Follower) -> Bool {
        lhs.identifier < rhs.identifier
    }
}

extension Follower: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(userID)
    }
}
