//
//  URLResource.swift
//  Library
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - URLResource

public protocol URLResource {
    var url: URL? { get }
}


// MARK: - URL

extension URL: URLResource {
    public var url: URL? { self }
}


// MARK: - String

extension String: URLResource {
    public var url: URL? { URL(string: self) }
}
