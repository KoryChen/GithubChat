//
//  MessageCell.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/8.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupViews() {
        contentView.addSubview(bgImageView)
        contentView.addSubview(messageLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bgImageView.bottomAnchor, constant: 15),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bgImageView.bottomAnchor)
        ])
    }
}


class OthersMessageCell: MessageCell {
    static let identifier = "OtherCell"
 
    override func setupViews() {
        super.setupViews()
        bgImageView.image = UIImage(named: "left_bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 22, bottom: 15, right: 14))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bgImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34)
        ])
    }
}

class MyMessageCell: MessageCell {
    static let identifier = "MyCell"
    
    override func setupViews() {
        super.setupViews()
        bgImageView.image = UIImage(named: "right_bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 14, bottom: 15, right: 22))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            bgImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bgImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -18),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28)
        ])
    }
}
