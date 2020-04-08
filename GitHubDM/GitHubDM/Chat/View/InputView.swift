//
//  InputView.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

protocol InputViewDelegate: class {
    func didSend(inputView: InputView, with text: String)
}

class InputView: UIView {
    weak var delegate: InputViewDelegate?
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(didClickSendButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Input here."
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        addSubview(textField)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
        ])

        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            sendButton.topAnchor.constraint(equalTo: textField.topAnchor),
            sendButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: 20)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        .zero
    }

    @objc
    private func didClickSendButton(_ sender: UIButton) {
        guard let input = textField.text else {
            return
        }
        textField.text = nil
        delegate?.didSend(inputView: self, with: input)
    }
    
}
