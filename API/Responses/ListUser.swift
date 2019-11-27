//
//  ListUser.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

public struct ListUser: Decodable {
    public let avatarUrl: String
    public let login: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}
