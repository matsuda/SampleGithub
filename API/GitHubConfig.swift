//
//  GitHubConfig.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

public class GitHubConfig {
    public static let shared: GitHubConfig = .init()

    public var token: String?

    private init() {}
}
