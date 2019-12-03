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
    func list(with username: String?, page: Int?) -> Single<RepoListResponse<[Repo]>>
}

final class UserRepoInteractor: UserRepoUseCase {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func list(with username: String?, page: Int? = nil) -> Single<RepoListResponse<[Repo]>> {
        let request =  UserRepoListRequest(username: username, page: page)
        return session.response(request: request)
    }
}
