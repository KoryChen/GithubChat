//
//  LinkHeaderTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM

class LinkHeaderTests: XCTestCase {

    func testNext() {
        let mockLink = "<https://api.github.com/users?since=46>; rel=\"next\", <https://api.github.com/users>; rel=\"first\""
        let link = LinkHeader(link: mockLink)
        
        XCTAssertNotNil(link?.next)
        XCTAssertEqual(link?.next, URL(string: "https://api.github.com/users?since=46")!)
    }
    
    func testFirst() {
        let mockLink = "<https://api.github.com/users?since=46>; rel=\"next\", <https://api.github.com/users>; rel=\"first\""
        let link = LinkHeader(link: mockLink)
        
        XCTAssertNotNil(link?.first)
        XCTAssertEqual(link?.first, URL(string: "https://api.github.com/users")!)
    }
    
    func testLast() {
        let mockLink = "<https://api.github.com/users?since=46>; rel=\"last\", <https://api.github.com/users>; rel=\"first\""
        let link = LinkHeader(link: mockLink)
        
        XCTAssertNotNil(link?.last)
        XCTAssertEqual(link?.last, URL(string: "https://api.github.com/users?since=46")!)
    }
    
    func testPrev() {
        
        let mockLink = "<https://api.github.com/users?since=46>; rel=\"next\", <https://api.github.com/users?since=13>; rel=\"prev\""
        let link = LinkHeader(link: mockLink)
        
        XCTAssertNotNil(link?.prev)
        XCTAssertEqual(link?.prev, URL(string: "https://api.github.com/users?since=13")!)
    }
}
