//
//  FollowerViewController.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

protocol FollowerViewControllerDelegate: class {
    func didSelectFollower(viewController: FollowerViewController, follower: Follower)
}

class FollowerViewController: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(FollowerTableViewCell.self, forCellReuseIdentifier: "followerCell")
        table.refreshControl = self.refreshControl
        return table
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    weak var delegate: FollowerViewControllerDelegate?
    let viewModel: FollowerViewModel
    init(viewModel: FollowerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        // Do any additional setup after loading the view.
        viewModel.fetchFollowers()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    func refreshTable(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        viewModel.fetchFollowers()
    }
}

extension FollowerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! FollowerTableViewCell
        if let follower = viewModel.follower(at: indexPath) {
            cell.setFollowerInfo(name: follower.userID, avtarURL: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! FollowerTableViewCell).endDisplayInScreen()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let follower = viewModel.follower(at: indexPath),
            let urlString = follower.avatarURL,
            let url = URL(string: urlString) else {
            return
        }
        
        (cell as! FollowerTableViewCell).avatarImageView.p_setImage(
            with: url,
            placeholder: nil, type: .avatar)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let follower = viewModel.follower(at: indexPath) else {
            return
        }
        delegate?.didSelectFollower(viewController: self, follower: follower)
    }
}

extension FollowerViewController: FollowerViewModelDelegate {
    func didSucceedToFetchFollower(viewModel: FollowerViewModel) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func didFailToFetchFollower(viewModel: FollowerViewModel, error: Error) {
        refreshControl.endRefreshing()
        let alertVC = UIAlertController(title: "Fetch Follower Failure.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(confirmAction)
        present(alertVC, animated: true, completion: nil)
    }
}
