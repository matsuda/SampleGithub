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
    func list(completion: @escaping (Result<[ListUser], SessionTaskError>) -> Void)
    func user(with username: String, completion: @escaping (Result<User, SessionTaskError>) -> Void)
    func fetchUser(with username: String) -> Single<User>
}

final class UserInteractor: UserUseCase {
    let session: Session

    init(session: Session) {
        self.session = session
    }

    func list(completion: @escaping (Result<[ListUser], SessionTaskError>) -> Void) {
        let request = UserListRequest()
        session.send(request, handler: completion)
    }
    
    func user(with username: String, completion: @escaping (Result<User, SessionTaskError>) -> Void) {
        let request = UserRequest(username: username)
        session.send(request, handler: completion)
    }

    func fetchUser(with username: String) -> Single<User> {
        let request = UserRequest(username: username)
        return session.response(request: request)
    }
}
