//
//  Repo.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

public struct Repo: Decodable {
    public let fullName: String
    public let language: String?
    public let forksCount: Int
    public let stargazersCount: Int
    public let description: String?
    public let fork: Bool
    public let htmlUrl: String

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case description
        case fork
        case htmlUrl = "html_url"
    }
}
