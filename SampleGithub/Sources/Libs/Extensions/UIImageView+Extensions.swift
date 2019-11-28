//
//  UIImageView+Extensions.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(url: URL?) {
        guard let url = url else {
            image = nil
            return
        }
        Nuke.loadImage(with: url, into: self)
    }
}
