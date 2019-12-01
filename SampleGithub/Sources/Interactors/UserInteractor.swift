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
    func list() -> Single<[ListUser]>
    func user(with username: String) -> Single<User>
}

final class UserInteractor: UserUseCase {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func list() -> Single<[ListUser]> {
        let request = UserListRequest()
        return session.response(request: request)
    }

    func user(with username: String) -> Single<User> {
        let request = UserRequest(username: username)
        return session.response(request: request)
    }
}
