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
            tableView.backgroundColor = Theme.Color.separator
            tableView.registerNib(RepoListCell.self)
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    private let headerView: RepoOwnerView = .loadNib()
    private let pagingView: LoadingView = .loadNib()
    private let refreshControl: UIRefreshControl = .init()

    private var username: String?
    private var viewModel: UserRepoListViewModel!
    private let disposeBag = DisposeBag()

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

    func configure(username: String) {
        self.username = username
    }
}

extension UserRepoListViewController {
    private func setupNavigation() {
        let text = "Repos"
        title = username.flatMap({ "\($0) \(text)" }) ?? text
    }

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }

    private func setupViewModel() {
        guard let username = username else {
            fatalError("username is missing")
        }

        let didRefresh = refreshControl.rx.controlEvent(.valueChanged)
            .map { [unowned self] (_) -> Bool in
                self.refreshControl.isRefreshing
        }
        let session = Session.shared
        viewModel = UserRepoListViewModel(
            username: username,
            viewWillAppear: rx.viewWillAppear,
            didRefresh: didRefresh,
            dependency: UserRepoListViewModel.Dependency(
                userUseCase: UserInteractor(session: session),
                repoUseCase: UserRepoInteractor(session: session)
            )
        )
        viewModel.loadingState.drive(onNext: handle(loadingState:)).disposed(by: disposeBag)
        viewModel.isRefreshing.drive(refreshControl.rx.isRefreshing).disposed(by: disposeBag)
    }

    private func handle(loadingState: LoadingState) {
        switch loadingState {
        case .loading(isFirst: true):
            updateTableFooterView(animated: true)
        case .loading(isFirst: false):
            updateTableFooterView(animated: true)
        case .idle:
            updateHeaderView()
            updateTableFooterView(animated: true)
            tableView.reloadData()
        case .finished:
            updateHeaderView()
            updateTableFooterView(animated: false)
            tableView.reloadData()
        case .failure(let error):
            print("error >>>", error)
            updateTableFooterView(animated: false)
        }
    }

    private func updateHeaderView() {
        guard headerView.superview == nil else { return }
        guard let user = viewModel.user else { return }
        headerView.configure(user)
        var size = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        size = headerView.systemLayoutSizeFitting(size,
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: size.height),
        ])
        let margin: CGFloat = 12
        tableView.contentInset = {
            var inset = tableView.contentInset
            inset.top = size.height + margin
            return inset
        }()
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
