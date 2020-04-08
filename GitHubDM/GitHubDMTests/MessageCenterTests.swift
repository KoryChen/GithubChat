//
//  MessageCenterTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/13.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM


class MessageCenterTests: XCTestCase {
    class MockMessageCenter: MessageCenter { }
    
    override class func setUp() {
        MockMessageCenter.shared.fileKey = "MockMessageCenter.dat"
    }
    
    override func tearDown() {
        cleanCacheIfNeeded()
    }
    
    func testMessageCenter() {
        let follower = Follower(identifier: 100, avatarURL: nil, userID: "follower1")
        let message = Message(content: "test", isOther: true)
        MockMessageCenter.shared.insertMessages(message, for: follower.userID)
        XCTAssertTrue(MockMessageCenter.shared.fetchMessages(userID: follower.userID).contains{
            $0.content == "test" && $0.isOther == true
        })
    }
    
    private func cleanCacheIfNeeded() {
        let filename = MockMessageCenter.shared.getDocumentsDirectory().appendingPathComponent(MockMessageCenter.shared.fileKey)
        guard FileManager.default.fileExists(atPath: filename.path) else {
            return
        }
        try? FileManager.default.removeItem(atPath: filename.path)
    }
}
