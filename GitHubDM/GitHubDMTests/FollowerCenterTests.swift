//
//  FollowerCenterTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM

class FollowerCenterTests: XCTestCase {
    class MockFollowerCenter: FollowerCenter { }
    
    override class func setUp() {
        MockFollowerCenter.shared.fileKey = "MockFollowerCenter.dat"
    }
    
    override func tearDown() {
        cleanCacheIfNeeded()
    }
    
    func testFollowerCenter() {
        let follower = Follower(identifier: 100, avatarURL: nil, userID: "follower1")
        FollowerCenter.shared.updateFollower(items: [follower])
        XCTAssertTrue(FollowerCenter.shared.followers.contains(follower))
    }
    
    private func cleanCacheIfNeeded() {
        let filename = MockFollowerCenter.shared.getDocumentsDirectory().appendingPathComponent(MockFollowerCenter.shared.fileKey)
        guard FileManager.default.fileExists(atPath: filename.path) else {
            return
        }
        try? FileManager.default.removeItem(atPath: filename.path)
    }
}
