//
//  LoadingView.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/12/02.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.hidesWhenStopped = true
            startAnimating()
        }
    }

    func startAnimating() {
        indicator.startAnimating()
    }

    func stopAnimating() {
        indicator.stopAnimating()
    }
}
