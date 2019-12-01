//
//  UserListViewModel.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift
import RxRelay
import RxCocoa

final class UserListViewModel {

    struct Dependency {
        let userUseCase: UserUseCase
    }

    private(set) var users: [ListUser] = []
    private let _loadingState: BehaviorRelay<LoadingState> = .init(value: .idle)
    var loadingState: Driver<LoadingState> {
        return _loadingState.distinctUntilChanged().asDriver(onErrorDriveWith: .empty())
    }

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    init(viewViewAppear: Observable<Void>,
         dependency: Dependency) {
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
        dependency.userUseCase.list()
            .subscribe(onSuccess: { [weak self] (users) in
                self?.users = users
                self?._loadingState.accept(.idle)
            }, onError: { error in
                print("error >>>>", error)
                self._loadingState.accept(.failure(error as! SessionTaskError))
            })
            .disposed(by: disposeBag)
    }
}
