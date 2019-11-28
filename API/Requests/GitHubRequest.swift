//
//  GitHubRequest.swift
//  API
//
//  Created by Kosuke Matsuda on 2019/11/28.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation
import APIKit

public protocol GitHubRequest: Request {}

extension GitHubRequest {
    public var baseURL: URL { URL(string: "https://api.github.com")! }

    public var dataParser: DataParser {
        return DecodableDataParser()
    }
}

extension GitHubRequest where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
//        #if DEBUG
        #if false
        if let jsonString = String(data: data, encoding: .utf8) {
            print("======================================")
            print(jsonString)
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                print("documentDirectory >>>>>", path)
                let file = (path as NSString).appendingPathComponent("\(self.path).json")
                do {
                    try jsonString.write(toFile: file, atomically: false, encoding: .utf8)
                } catch {
                    print("error >>>", error)
                }
            }
            print("======================================")
        }
        #endif
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
