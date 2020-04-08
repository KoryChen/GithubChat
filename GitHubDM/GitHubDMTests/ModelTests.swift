//
//  ModelTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM
class ModelTests: XCTestCase {

    func testFollowerModel() {
        let followerRaw = "{\"login\":\"simonjefford\",\"id\":1,\"avatar_url\":\"https://avatars0.githubusercontent.com/u/1?v=4\"}"
        let data = followerRaw.data(using: .utf8)!
        let decoder = JSONDecoder()
        let follower = try? decoder.decode(Follower.self, from: data)
        XCTAssertNotNil(follower)
    }
    
    func testFollowerCompareID() {
        let follower1 = Follower(identifier: 1, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "aaa")
        let follower2 = Follower(identifier: 2, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "bbb")
        XCTAssertTrue(follower1 < follower2)
    }
    
    func testFollowerEqual() {
        let follower1 = Follower(identifier: 1, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "aaa")
        let follower2 = Follower(identifier: 1, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "aaa")
        XCTAssertTrue(follower1 == follower2)
    }
    
    func testFollowerNonEqual() {
        let follower1 = Follower(identifier: 1, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "aaa")
        let follower2 = Follower(identifier: 2, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "bbb")
        XCTAssertTrue(follower1 != follower2)
    }

}
