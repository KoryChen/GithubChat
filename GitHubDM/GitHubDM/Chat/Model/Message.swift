//
//  Message.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/8.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

struct Message: Codable {
    let content: String
    let createDate = Date()
    let isOther: Bool
}
