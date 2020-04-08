//
//  APIRequest.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var url: URL { get }
    var method: HTTPMethod { get }
}

extension APIRequest {
    func buildRequest() -> URLRequest {
        var requst = URLRequest(url: url)
        requst.httpMethod = method.rawValue
        return requst
    }
}

struct FollowersRequest: APIRequest {
    typealias Response = [Follower]
    var url: URL = URL(string:"https://api.github.com/users?since=135")!
    var method: HTTPMethod = .GET
}
