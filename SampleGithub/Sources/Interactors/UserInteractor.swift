//
//  UserInteractor.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

protocol UserUseCase {
    func list() -> [User]
    func user(with login: String) -> User?
}

class UserInteractor: UserUseCase {
    func list() -> [User] {
        return []
    }
    
    func user(with login: String) -> User? {
        return nil
    }
}
