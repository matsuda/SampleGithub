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

protocol UserUseCase {
    func list(completion: @escaping (Result<[ListUser], SessionTaskError>) -> Void)
    func user(with username: String, completion: @escaping (Result<User, SessionTaskError>) -> Void)
}

final class UserInteractor: UserUseCase {
    func list(completion: @escaping (Result<[ListUser], SessionTaskError>) -> Void) {
        let request = UserListRequest()
        Session.send(request, handler: completion)
    }
    
    func user(with username: String, completion: @escaping (Result<User, SessionTaskError>) -> Void) {
        let request = UserRequest(username: username)
        Session.send(request, handler: completion)
    }
}
