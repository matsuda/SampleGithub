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

protocol UserRepoUseCase {
    func repoList(username: String?,
                  completion: @escaping (Result<[Repo], SessionTaskError>) -> Void)
}

final class nameUserRepoInteractor: UserRepoUseCase {
    func repoList(username: String?,
                  completion: @escaping (Result<[Repo], SessionTaskError>) -> Void)  {
        let request =  UserRepoListRequest(username: username)
        Session.send(request, handler: completion)
    }
}
