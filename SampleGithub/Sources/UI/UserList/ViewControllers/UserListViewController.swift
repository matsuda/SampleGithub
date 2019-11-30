//
//  UserListViewController.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library

final class UserListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(UserListCell.self)
        }
    }

    private var viewModel: UserListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func startRequest() {
        viewModel.fetch { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension UserListViewController {
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startRequest))
    }

    private func setupViewModel() {
        viewModel = UserListViewModel(
            usecase: UserInteractor()
        )
    }
}

// MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserListCell.self, for: indexPath)
        let user = viewModel.users[indexPath.row]
        cell.configure(user)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserRepoListViewController.make()
        navigationController?.pushViewController(vc, animated: true)
    }
}
