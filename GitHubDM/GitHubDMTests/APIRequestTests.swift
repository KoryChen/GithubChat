//
//  APIRequestTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/11.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM

class APIRequestTests: XCTestCase {
    struct MockResponse: Codable {
        let result: String
    }
    
    struct MockRequest: APIRequest {
        typealias Response = MockResponse
        var url: URL = URL(string: "https://google.com")!
        var method: HTTPMethod = .GET
    }
    
    func testRequestMethod() {
        let request = MockRequest(
            url: URL(string: "https://google.com")!,
            method: .GET).buildRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testRequestURL() {
        let request = MockRequest(
            url: URL(string: "https://google.com")!,
            method: .GET).buildRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://google.com")
    }
}
