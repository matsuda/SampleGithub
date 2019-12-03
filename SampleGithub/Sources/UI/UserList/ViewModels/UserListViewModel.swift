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
    var isRefreshing: Driver<Bool> {
        loadingState.map { (state) -> Bool in
            if case .loading(true) = state {
                return true
            }
            return false
        }
        .distinctUntilChanged()
        .asDriver()
    }

    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    private var nextPage: Int?

    deinit {
        print(self, ":", #function)
    }

    init(viewWillAppear: Observable<Void>,
         didRefresh: Observable<Bool>,
         dependency: Dependency) {
        self.dependency = dependency

        let firstViewWillAppear = viewWillAppear.take(1)
        let isRefreshing = didRefresh.filter { $0 }.void()

        Observable.merge(
            firstViewWillAppear,
            isRefreshing)
            .subscribe(onNext: { [weak self] (_) in
                self?.fetch()
            })
            .disposed(by: disposeBag)
    }

    func pagingIfNeeded(at index: Int) {
        let threshold = 10
        let shouldLoad: Bool = (users.count - index < threshold)
        guard shouldLoad else { return }
        fetch(isFirst: false)
    }

    private func fetch(isFirst: Bool = true) {
        switch _loadingState.value {
        case .loading: return
        case .finished where !isFirst: return
        default: break
        }

        _loadingState.accept(.loading(isFirst: isFirst))
        let page: Int? = isFirst ? nil : nextPage

        let first = Single<Bool>.just(isFirst)
        let request = dependency.userUseCase.list(page: page)
        Single.zip(request, first)
            .subscribe(onSuccess: handle(response:isFirst:),
                       onError: handle(error:))
            .disposed(by: disposeBag)
    }

    private func handle(response: ListUserResponse<[ListUser]>, isFirst: Bool) {
        let elements = response.elements
        if isFirst {
            users.removeAll()
            users = elements
        } else {
            users.append(contentsOf: elements)
        }

        nextPage = response.nextPage

        let state: LoadingState = elements.isEmpty ? .finished : .idle
        _loadingState.accept(state)
    }

    private func handle(error: Error) {
        print("error >>>>", error)
        _loadingState.accept(.failure(error))
    }
}
