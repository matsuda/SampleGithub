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

    private var viewModel: UserRepoListViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.fetchRepos() { [weak self] in
//            self?.tableView.reloadData()
//        }
    }
}

extension UserRepoListViewController {
    private func setupViewModel() {
        let session = Session.shared
        viewModel = UserRepoListViewModel(
            username: "",
            viewViewAppear: self.rx.viewWillAppear,
            dependency: UserRepoListViewModel.Dependency(
                userUseCase: UserInteractor(session: session),
                repoUseCase: UserRepoInteractor(session: session)
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
        let entity = viewModel.repos[indexPath.row]
        guard let url = URL(string: entity.htmlUrl) else {
            return
        }
        let vc = WebViewController.make()
        vc.configure(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
