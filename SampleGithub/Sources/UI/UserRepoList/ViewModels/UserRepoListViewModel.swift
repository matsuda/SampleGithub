//
//  UserRepoListViewModel.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API

final class UserRepoListViewModel {
    struct Dependency {
        let usecase: UserRepoUseCase
    }

    private(set) var repos: [Repo] = []

    private let username: String
    private let dependency: Dependency

    init(username: String, dependency: Dependency) {
        self.username = username
        self.dependency = dependency
    }

    func fetchRepos(completion: @escaping () -> Void) {
        dependency.usecase.repoList(username: username) { (result) in
            switch result {
            case .success(let repos):
                self.repos = repos.filter { !$0.fork }
//                print("repos >>>", self.repos)
            case .failure(let error):
                print("error >>>", error)
                break
            }
            completion()
        }
    }
}
