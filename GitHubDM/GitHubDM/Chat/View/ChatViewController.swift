//
//  ChatViewController.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/8.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        tableView.register(OthersMessageCell.self, forCellReuseIdentifier: OthersMessageCell.identifier)
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: MyMessageCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset.bottom = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width - 20, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        return layout
    }()
    
    lazy var chatInputView: UIView = {
        let inputView = InputView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
        inputView.delegate = self
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    let viewModel: ChatViewModel
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupHandlingKeyboard()
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }

    override var inputAccessoryView: UIView {
        chatInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.chatTitle()
        setupViews()
        viewModel.fetchMessages()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToBottomIfNeeded()
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func scrollToBottomIfNeeded() {
        guard tableView.contentSize.height > tableView.bounds.height else {
            return
        }
        let indexPath = IndexPath(
            item: self.viewModel.messages.count - 1,
            section: 0
        )
        DispatchQueue.main.async {
            self.tableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: true)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.calculateItemHeight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = viewModel.message(at: indexPath) else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        
        let cell: UITableViewCell
        if message.isOther {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: OthersMessageCell.identifier, for: indexPath) as! OthersMessageCell
            let message = viewModel.message(at: indexPath)
            otherCell.messageLabel.text = message?.content
            cell = otherCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MyMessageCell.identifier, for: indexPath) as! MyMessageCell
            let message = viewModel.message(at: indexPath)
            myCell.messageLabel.text = message?.content
            cell = myCell
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(false)
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func didFetchMessages(viewModel: ChatViewModel) {
        
    }
    
    func didFailToFetchMessages(viewModel: ChatViewModel, error: Error) {
        let alertVC = UIAlertController(title: "Warning!", message: "Fetch Messages Failure.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(confirmAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func didSendMessage(viewModel: ChatViewModel) {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToBottomIfNeeded()
        }
    }
}

extension ChatViewController: InputViewDelegate {
    func didSend(inputView: InputView, with text: String) {
        guard text.isEmpty == false else { return }
        viewModel.sendMessage(content: text)
    }
}
