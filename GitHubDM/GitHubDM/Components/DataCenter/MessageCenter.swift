//
//  MessageCenter.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class MessageCenter: DataCenter {
    typealias DataType = [String: [Message]]
    
    internal var fileKey: String = "MessageCenterData.dat"
    private let queue =
        DispatchQueue(
            label: "message.concurrent",
            attributes: .concurrent)
    private var messageRepo: DataType = [:]
    
    static let shared = MessageCenter()
    
    init() {
        do {
            messageRepo = try (self.load() ?? [:])
        } catch {
            messageRepo = [:]
            //TODO: handle Error
        }
    }
  
    func fetchMessages(userID: String) -> [Message] {
        var copyMessages: [Message]!
        queue.sync {
            copyMessages = messageRepo[userID] ?? []
        }
        return copyMessages
    }
    
    func insertMessages(_ message: Message, for userID: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            var messages: [Message] = self.messageRepo[userID] ?? []
            messages.append(message)
            self.messageRepo[userID] = messages
            self.save(data: self.messageRepo)
        }
    }
}
