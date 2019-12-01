//
//  UserRepoListViewModel.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift
import RxRelay
import RxCocoa

final class UserRepoListViewModel {

    struct Dependency {
        let userUseCase: UserUseCase
        let repoUseCase: UserRepoUseCase
    }

    private(set) var user: User?
    private(set) var repos: [Repo] = []
    private let _loadingState: BehaviorRelay<LoadingState> = .init(value: .idle)
    var loadingState: Driver<LoadingState> {
        return _loadingState.distinctUntilChanged().asDriver(onErrorDriveWith: .empty())
    }

    private let username: String
    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    /// output

    init(username: String,
         viewViewAppear: Observable<Void>,
         dependency: Dependency) {
        self.username = username
        self.dependency = dependency
        viewViewAppear.take(1)
            .subscribe(onNext: { [weak self] (_) in
                self?.fetch()
            })
            .disposed(by: disposeBag)
    }

    func fetch() {
        if case .loading = _loadingState.value {
            return
        }

        _loadingState.accept(.loading)
        let userRequest = dependency.userUseCase.user(with: username)
        let repoRequest = dependency.repoUseCase.list(with: username)
        Single
            .zip(userRequest, repoRequest)
            .subscribe(onSuccess: { [weak self] (user, repos) in
                self?.user = user
                self?.repos = repos
                self?._loadingState.accept(.idle)
            }, onError: { error in
                print("error >>>>", error)
                self._loadingState.accept(.failure(error as! SessionTaskError))
            })
            .disposed(by: disposeBag)
    }
}
