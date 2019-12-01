//
//  UserListViewController.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library
import APIKit
import RxSwift

final class UserListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(UserListCell.self)
        }
    }

    private var viewModel: UserListViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViewModel()
        /// WARN: after create VM
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow()
    }

}

extension UserListViewController {
    private func setupNavigation() {
        title = "Users"
    }

    private func setupViewModel() {
        viewModel = UserListViewModel(
            viewViewAppear: rx.viewWillAppear,
            dependency: UserListViewModel.Dependency(
                userUseCase: UserInteractor(session: Session.shared)
            )
        )
        viewModel.loadingState
            .drive(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .loading:
                    break
                case .idle:
                    self.tableView.reloadData()
                    break
                case .finished:
                    self.tableView.reloadData()
                    break
                case .failure(let error):
                    break
                }
            })
            .disposed(by: disposeBag)
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
        let user = viewModel.users[indexPath.row]
        vc.configure(username: user.login)
        navigationController?.pushViewController(vc, animated: true)
    }
}
