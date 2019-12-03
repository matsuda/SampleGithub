//
//  UserRepoListViewController.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library
import APIKit
import RxSwift

final class UserRepoListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(RepoListCell.self)
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    private let headerView: RepoOwnerView = .loadNib()
    private let pagingView: LoadingView = .loadNib()

    private var username: String?
    private var viewModel: UserRepoListViewModel!
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

    func configure(username: String) {
        self.username = username
    }
}

extension UserRepoListViewController {
    private func setupNavigation() {
        let text = "Repos"
        title = username.flatMap({ "\($0) \(text)" }) ?? text
    }

    private func setupViewModel() {
        guard let username = username else {
            fatalError("username is missing")
        }

        let session = Session.shared
        viewModel = UserRepoListViewModel(
            username: username,
            viewViewAppear: rx.viewWillAppear,
            dependency: UserRepoListViewModel.Dependency(
                userUseCase: UserInteractor(session: session),
                repoUseCase: UserRepoInteractor(session: session)
            )
        )
        viewModel.loadingState
            .drive(onNext: handle(loadingState:))
            .disposed(by: disposeBag)
    }

    private func handle(loadingState: LoadingState) {
        switch loadingState {
        case .loading(isFirst: true):
            updateTableHeaderView()
            updateTableFooterView(animated: true)
        case .loading(isFirst: false):
            updateTableFooterView(animated: true)
        case .idle:
            updateTableHeaderView()
            updateTableFooterView(animated: true)
            tableView.reloadData()
        case .finished:
            updateTableHeaderView()
            updateTableFooterView(animated: false)
            tableView.reloadData()
        case .failure(let error):
            print("error >>>", error)
            updateTableFooterView(animated: false)
        }
    }

    private func updateTableHeaderView() {
        if let user = viewModel.user {
            headerView.configure(user)
            tableView.tableHeaderView = headerView
            tableView.sizeToFitHeaderView()
        } else {
            tableView.tableHeaderView = nil
        }
    }

    private func updateTableFooterView(animated: Bool) {
        if animated {
            pagingView.startAnimating()
            tableView.tableFooterView = pagingView
        } else {
            pagingView.stopAnimating()
            tableView.tableFooterView = UIView()
        }
    }
}

// MARK: - UITableViewDataSource

extension UserRepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RepoListCell.self, for: indexPath)
        let repo = viewModel.repos[indexPath.row]
        cell.configure(repo)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.pagingIfNeeded(at: indexPath.row)
    }
}


// MARK: - UITableViewDelegate

extension UserRepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = viewModel.repos[indexPath.row]
        guard let url = URL(string: entity.htmlUrl) else { return }
        let vc = WebViewController.make()
        vc.configure(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
