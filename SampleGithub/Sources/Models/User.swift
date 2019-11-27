//
//  User.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

struct User {
    let avatarUrl: String
    let login: String
    let name: String
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
        case name
        case followers
        case following
    }
}
