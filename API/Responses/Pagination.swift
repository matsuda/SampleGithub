//
//  Pagination.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/12/02.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

public protocol PaginationResponse {
    associatedtype Element: Decodable
    var elements: Element { get }
    var nextURI: String? { get }
    init(elements: Element, nextURI: String?)
}

//public struct AnyPaginationResponse<Element: Decodable>: PaginationResponse {
//    public let elements: Element
//    public let nextLink: String?
//
//    init<Response: PaginationResponse>(response: Response) where Response.Element == Element {
//        elements = response.elements
//        page = response.page
//        nextPage = response.nextPage
//    }
//
//    public init(elements: Element, page: Int, nextPage: Int?) {
//        self.elements = elements
//        self.page = page
//        self.nextPage = nextPage
//    }
//}

public protocol PaginationRequest: GitHubRequest where Response: PaginationResponse {}
