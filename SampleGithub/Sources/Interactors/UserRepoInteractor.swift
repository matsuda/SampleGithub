//
//  UserRepoInteractor.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift

protocol UserRepoUseCase {
    func repoList(username: String?,
                  completion: @escaping (Result<[Repo], SessionTaskError>) -> Void)
    func fetchRepoList(username: String?) -> Single<[Repo]>
}

final class UserRepoInteractor: UserRepoUseCase {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func repoList(username: String?,
                  completion: @escaping (Result<[Repo], SessionTaskError>) -> Void)  {
        let request =  UserRepoListRequest(username: username)
        session.send(request, handler: completion)
    }

    func fetchRepoList(username: String?) -> Single<[Repo]> {
        let request =  UserRepoListRequest(username: username)
        return session.response(request: request)
    }
}
