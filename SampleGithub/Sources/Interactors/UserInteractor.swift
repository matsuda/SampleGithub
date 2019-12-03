//
//  UserInteractor.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API
import APIKit
import RxSwift

protocol UserUseCase {
    func list(page: Int?) -> Single<ListUserResponse<[ListUser]>>
    func user(with username: String) -> Single<User>
}

final class UserInteractor: UserUseCase {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func list(page: Int? = nil) -> Single<ListUserResponse<[ListUser]>> {
        let request = UserListRequest(page: page)
        return session.response(request: request)
    }

    func user(with username: String) -> Single<User> {
        let request = UserRequest(username: username)
        return session.response(request: request)
    }
}
