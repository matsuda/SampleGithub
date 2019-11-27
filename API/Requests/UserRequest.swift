//
//  UserRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit

public struct UserListRequest: GitHubRequest {
    public typealias Response = [ListUser]

    public var path: String = "/users"
    public var method: HTTPMethod = .get

    public init() {}
}

public struct UserRequest: GitHubRequest {
    public typealias Response = User

    public var path: String {
        "/users/\(username)"
    }
    public var method: HTTPMethod = .get

    private let username: String

    public init(username: String) {
        self.username = username
    }
}
