//
//  HTTPClientTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/11.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM

class MockURLSessionDataTask: URLSessionDataTask {
    var fakeState: URLSessionTask.State
    
    init(state:URLSessionTask.State = URLSessionTask.State.running) {
        self.fakeState = state
    }
}

class HTTPClientTests: XCTestCase {
    class FollowerMockSession: URLSession {
        static let mockData = "[{\"login\":\"simonjefford\",\"id\":1,\"avatar_url\":\"https://avatars0.githubusercontent.com/u/1?v=4\"}]".data(using: .utf8)
        static let mockMalData = "{\"login\":\"simonjefford\",\"id\":1,\"avatar_url\":\"https://avatars0.githubusercontent.com/u/1?v=4\"".data(using: .utf8)
        enum MockType {
            case success
            case decodeFail
            case error
            case noData
        }
        
        var type: MockType = .success
        convenience init(type: MockType) {
            self.init()
            self.type = type
        }
        
        override init() {
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            switch type {
            case .success:
                completionHandler(FollowerMockSession.mockData, nil, nil)
            case .decodeFail:
                completionHandler(FollowerMockSession.mockMalData, nil, nil)
            case .error:
                completionHandler(nil, nil, APIError.nilData)
            case .noData:
                completionHandler(nil,nil,nil)
            }
            return MockURLSessionDataTask()
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            completionHandler(FollowerMockSession.mockData, nil, nil)
            return MockURLSessionDataTask()
        }
    }
    
    func testRunTaskSuccess() {
        let httpClient = HTTPClient(session: FollowerMockSession(type: .success))
        let request = FollowersRequest()
        let mockFollowers = [Follower(identifier: 1, avatarURL: "https://avatars0.githubusercontent.com/u/1?v=4", userID: "simonjefford")]
        httpClient.runTask(with: request) { (result) in
            switch result {
            case .success(let followers):
                XCTAssertEqual(followers, mockFollowers)
                break
            case .failure(_):
                XCTAssert(false)
            }
        }.resume()
    }
    
    func testRunTaskMalData() {
        let httpClient = HTTPClient(session: FollowerMockSession(type: .decodeFail))
        let request = FollowersRequest()
        httpClient.runTask(with: request) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
        }.resume()
    }
    
    func testRunTaskNoData() {
        let httpClient = HTTPClient(session: FollowerMockSession(type: .noData))
        let request = FollowersRequest()
        httpClient.runTask(with: request) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }.resume()
    }
    
    func testRunTaskError() {
        let httpClient = HTTPClient(session: FollowerMockSession(type: .noData))
        let request = FollowersRequest()
        httpClient.runTask(with: request) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }.resume()
    }
    
    func testPerform() {
        let httpClient = HTTPClient(session: FollowerMockSession())
        httpClient.performRequest(URL(string: "https://goolge.com")!) { (data, response, error) in
            XCTAssertEqual(data, FollowerMockSession.mockData)
        }
    }
}
