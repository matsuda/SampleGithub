//
//  Repo.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    let name: String
    let language: String?
    let stargazersCount: Int
    let description: String
    let fork: Bool
    let htmlUrl: String

    enum CodingKeys: String, CodingKey {
        case name
        case language
        case stargazersCount = "stargazers_count"
        case description
        case fork
        case htmlUrl = "html_url"
    }
}
