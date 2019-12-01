//
//  UserRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit

// MARK: - UserListRequest

public struct UserListRequest: GitHubRequest, PaginationRequest {
    public typealias Response = ListUserResponse<[ListUser]>

    public var path: String = "/users"
    public var queryParameters: [String : Any]? {
        if let since = since {
            return ["since": since]
        }
        return nil
    }

    public let since: Int?

    public init(since: Int? = nil) {
        self.since = since
    }
}


// MARK: - UserRequest

public struct UserRequest: GitHubRequest {
    public typealias Response = User

    public var path: String {
        "/users/\(username)"
    }

    private let username: String

    public init(username: String) {
        self.username = username
    }
}
