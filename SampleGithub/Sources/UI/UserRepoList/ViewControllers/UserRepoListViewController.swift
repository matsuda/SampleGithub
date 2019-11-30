//
//  UserRepoListViewController.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library

final class UserRepoListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(RepoListCell.self)
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    private var viewModel: UserRepoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchRepos() { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension UserRepoListViewController {
    private func setupViewModel() {
        viewModel = UserRepoListViewModel(
            username: "",
            dependency: UserRepoListViewModel.Dependency(
                usecase: nameUserRepoInteractor()
            )
        )
    }
}

// MARK: - UITableViewDataSource

extension UserRepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RepoListCell.self, for: indexPath)
        let entity = viewModel.repos[indexPath.row]
        cell.configure(entity)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension UserRepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
