//
//  Pagination.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/12/02.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

// MARK: - PaginationResponse

public protocol PaginationResponse {
    associatedtype Element: Decodable
    var elements: Element { get }
    var nextPage: Int? { get }
    init(elements: Element, nextPage: Int?)
}


// MARK: - PaginationRequest

public protocol PaginationRequest: GitHubRequest where Response: PaginationResponse {
    var nextPageKey: String { get }
    var page: Int? { get set }
}

extension PaginationRequest {
    public var queryParameters: [String : Any]? {
        if let page = page {
            return [nextPageKey: page]
        }
        return nil
    }
}
