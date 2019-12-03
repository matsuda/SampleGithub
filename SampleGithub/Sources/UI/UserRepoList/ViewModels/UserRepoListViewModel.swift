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

    typealias Element = (User?, RepoListResponse<[Repo]>)

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
    var isRefreshing: Driver<Bool> {
        loadingState.map { [unowned self] (state) -> Bool in
            if case .loading(let isFirst) = state, isFirst && !self.repos.isEmpty {
                return true
            }
            return false
        }
        .distinctUntilChanged()
        .asDriver()
    }

    private let username: String
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    private var nextPage: Int?

    /// output

    init(username: String,
         viewWillAppear: Observable<Void>,
         didRefresh: Observable<Bool>,
         dependency: Dependency) {
        self.username = username
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
        let shouldLoad: Bool = (repos.count - index < threshold)
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
        Single
            .zip(request(page: page, isFirst: isFirst), first)
            .subscribe(onSuccess: handle(response:isFirst:), onError: handle(error:))
            .disposed(by: disposeBag)
    }

    private func request(page: Int?, isFirst: Bool = true) -> Single<Element> {
        let repoRequest = dependency.repoUseCase.list(with: username, page: page)
        if isFirst {
            let userRequest = dependency.userUseCase.user(with: username)
            return Single.zip(userRequest, repoRequest).map { ($0.0, $0.1) }
        } else {
            return repoRequest.map { (nil, $0) }
        }
    }

    private func handle(response: Element, isFirst: Bool) {
        let reposResponse = response.1
        let elements = reposResponse.elements.filter({ !$0.fork })

        if isFirst {
            user = response.0
            repos = elements
        } else {
            repos.append(contentsOf: elements)
        }

        nextPage = reposResponse.nextPage

        let state: LoadingState = nextPage == nil ? .finished : .idle
        _loadingState.accept(state)
    }

    private func handle(error: Error) {
        print("error >>>>", error)
        _loadingState.accept(.failure(error))
    }
}
