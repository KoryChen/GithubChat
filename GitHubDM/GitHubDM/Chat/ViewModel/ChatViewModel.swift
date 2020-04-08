//
//  ChatViewModel.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/8.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

protocol ChatViewModelDelegate: class {
    func didFetchMessages(viewModel: ChatViewModel)
    func didFailToFetchMessages(viewModel: ChatViewModel, error: Error)
    func didSendMessage(viewModel: ChatViewModel)
}

class ChatViewModel {
    weak var delegate: ChatViewModelDelegate?
    
    private(set) var messages: [Message] = []
    let follower: Follower
    init(follower: Follower) {
        self.follower = follower
    }
    
    func chatTitle() -> String {
        "@\(follower.userID)"
    }
    
    func message(at indexPath: IndexPath) -> Message? {
        guard indexPath.item < messages.count else {
            return nil
        }
        return messages[indexPath.item]
    }
    
    func calculateItemHeight(at indexPath: IndexPath) -> CGFloat {
        guard let message = message(at: indexPath) else {
            return .zero
        }
        
        let content = message.content as NSString
        let width = (UIScreen.main.bounds.width - 20.0) * 0.75
        return content.boundingRect(
            with: CGSize(width: width , height: CGFloat.greatestFiniteMagnitude),
            options: [
                .usesFontLeading,
                .usesLineFragmentOrigin
            ],
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)
            ],
            context: nil).size.height + 30 + 15//top and bottom inset 
    }
    
    func fetchMessages() {
        messages = MessageCenter.shared.fetchMessages(userID: follower.userID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.didFetchMessages(viewModel: self)
        }
    }
    
    func sendMessage(content: String) {
        let message = Message(content: content, isOther: false)
        MessageCenter.shared.insertMessages(message, for: follower.userID)
        messages = MessageCenter.shared.fetchMessages(userID: follower.userID)
        self.delegate?.didSendMessage(viewModel: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mockReply(with: content)
        }
    }
    
    private func mockReply(with content: String) {
        let doubleContent: String = "\(content) \(content)"
        let reply = Message(content: doubleContent, isOther: true)
        MessageCenter.shared.insertMessages(reply, for: follower.userID)
        messages = MessageCenter.shared.fetchMessages(userID: follower.userID)
        self.delegate?.didSendMessage(viewModel: self)
    }
}
