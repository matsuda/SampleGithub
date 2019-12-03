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
    private let pagingView: LoadingView = .loadNib()
    private let refreshControl: UIRefreshControl = .init()

    private var viewModel: UserListViewModel!
    private let disposeBag = DisposeBag()

    deinit {
        print(self, ":", #function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupRefreshControl()
        setupViewModel()
        /// WARN: after create VM
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeToFitFooterView()
    }
}

extension UserListViewController {
    private func setupNavigation() {
        title = "Users"
    }

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }

    private func setupViewModel() {
        let didRefresh = refreshControl.rx.controlEvent(.valueChanged)
            .map { [unowned self] (_) -> Bool in
                self.refreshControl.isRefreshing
            }
        viewModel = UserListViewModel(
            viewWillAppear: rx.viewWillAppear,
            didRefresh: didRefresh,
            dependency: UserListViewModel.Dependency(
                userUseCase: UserInteractor(session: Session.shared)
            )
        )
        viewModel.loadingState
            .drive(onNext: { [weak self] (state) in
                self?.handle(loadingState: state)
            })
            .disposed(by: disposeBag)
        viewModel.isRefreshing.drive(refreshControl.rx.isRefreshing).disposed(by: disposeBag)
    }

    private func handle(loadingState: LoadingState) {
        switch loadingState {
        case .loading(isFirst: true):
            updateTableFooterView(animated: true)
        case .loading(isFirst: false):
            updateTableFooterView(animated: true)
        case .idle:
            updateTableFooterView(animated: true)
            tableView.reloadData()
        case .finished:
            updateTableFooterView(animated: false)
            tableView.reloadData()
        case .failure(let error):
            print("error >>>", error)
            updateTableFooterView(animated: false)
        }
    }

    private func updateTableFooterView(animated: Bool) {
        if animated {
            pagingView.startAnimating()
            tableView.tableFooterView = pagingView
        } else {
            pagingView.stopAnimating()
            tableView.tableFooterView = nil
        }
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.pagingIfNeeded(at: indexPath.row)
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
