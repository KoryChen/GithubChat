//
//  APIError.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

enum GeneralError: Error {
    case notFound
}

enum APIError: Error {
    case nilData
}
