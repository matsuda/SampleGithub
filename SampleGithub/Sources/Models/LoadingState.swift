//
//  LoadingState.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/12/02.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import Foundation

enum LoadingState: Equatable {
    case idle, loading(isFirst: Bool), finished, failure(Error)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading(let v1), .loading(let v2)) where v1 == v2:
            return true
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}
