//
//  Reusable.swift
//  Library
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit

// MARK: - Reusable

public protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    public static var reusableIdentifier: String {
        return String(describing: self)
    }
}
