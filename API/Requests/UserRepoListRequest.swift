//
//  UserRepoListRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit

// MARK: - UserRepoListRequest

public struct UserRepoListRequest: GitHubRequest, PaginationRequest {
    public typealias Response = RepoListResponse<[Repo]>

    public var path: String {
        if let username = username {
            return "/users/\(username)/repos"
        } else {
            return "/users/repos"
        }
    }

    public let nextPageKey: String = "page"
    public var page: Int?
    private let username: String?

    public init(username: String? = nil, page: Int? = nil) {
        self.username = username
        self.page = page
    }
}
