//
//  UserListViewModel.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import API

final class UserListViewModel {
    private(set) var users: [ListUser] = []

    private let usecase: UserUseCase

    init(usecase: UserUseCase) {
        self.usecase = usecase
    }

    func fetch(completion: @escaping () -> Void) {
        usecase.list { (result) in
            switch result {
            case .success(let users):
                self.users = users
                print("users >>>", users)
            case .failure(let error):
                print("error >>>", error)
                break
            }
            completion()
        }
    }
}
