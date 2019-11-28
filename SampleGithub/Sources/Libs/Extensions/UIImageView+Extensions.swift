//
//  UIImageView+Extensions.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Library
import Nuke

extension UIImageView {
    func loadImage(with resource: URLResource?) {
        guard let url = resource?.url else {
            image = nil
            return
        }
        Nuke.loadImage(with: url, into: self)
    }
}
