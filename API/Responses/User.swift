//
//  User.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public let avatarUrl: String
    public let login: String
    public let name: String
    public let location: String?
    public let bio: String?
    public let publicRepos: Int
    public let followers: Int
    public let following: Int

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
        case name
        case location
        case bio
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
