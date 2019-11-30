//
//  UserRepoListRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

import APIKit

public struct UserRepoListRequest: GitHubRequest {
    public typealias Response = [Repo]

    public var path: String {
        if let username = username {
            return "/users/\(username)/repos"
        } else {
            return "/users/repos"
        }
    }
    public var method: HTTPMethod = .get

    private let username: String?

    public init(username: String? = nil) {
        self.username = username
    }
}
