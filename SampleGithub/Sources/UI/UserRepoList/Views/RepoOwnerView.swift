//
//  RepoOwnerView.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/12/01.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import API

final class RepoOwnerView: UIView {
    typealias Entity = User

    @IBOutlet private weak var avatarView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel! {
        didSet {
            loginLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            loginLabel.textColor = Theme.Color.link
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    @IBOutlet private weak var reposLabel: UILabel! {
        didSet {
            reposLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        }
    }
    @IBOutlet private weak var followersLabel: UILabel! {
        didSet {
            followersLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        }
    }
    @IBOutlet private weak var followingLabel: UILabel! {
        didSet {
            followingLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        }
    }
    @IBOutlet private var countCaptionLabels: [UILabel]! {
        didSet {
            countCaptionLabels.forEach {
                $0.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                $0.textColor = UIColor.gray
            }
        }
    }
    @IBOutlet private weak var locationLabel: UILabel! {
        didSet {
            locationLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            locationLabel.textColor = UIColor.gray
        }
    }
    @IBOutlet private weak var bioLabel: UILabel! {
        didSet {
            bioLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            bioLabel.textColor = UIColor.gray
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = Theme.Color.separator
        }
    }

    func configure(_ entity: Entity) {
        avatarView.loadImage(with: entity.avatarUrl)
        loginLabel.text = entity.login
        nameLabel.text = "(\(entity.name))"
        reposLabel.text = "\(entity.publicRepos)"
        followersLabel.text = "\(entity.followers)"
        followingLabel.text = "\(entity.following)"
        if let value = entity.location {
            locationLabel.text = value
            locationLabel.superview?.isHidden = false
        } else {
            locationLabel.text = nil
            locationLabel.superview?.isHidden = true
        }
        if let value = entity.bio {
            bioLabel.text = value
            bioLabel.isHidden = false
        } else {
            bioLabel.text = nil
            bioLabel.isHidden = true
        }
    }
}


final class SeparatorBackgroundView: UIView {
    private var separatorColor: UIColor = {
        UITableView().separatorColor!
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        do {
            let layer = CALayer()
            layer.backgroundColor = separatorColor.cgColor
            self.layer.addSublayer(layer)
        }
//        do {
//            let layer = CALayer()
//            layer.backgroundColor = separatorColor.cgColor
//            self.layer.addSublayer(layer)
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 0.5
        if let layer = layer.sublayers?.first {
            layer.frame = CGRect(x: 0, y: 0,
                                 width: bounds.width, height: height)
        }
//        if let layer = layer.sublayers?.last {
//            layer.frame = CGRect(x: 0, y: bounds.maxY - height,
//                                 width: bounds.width, height: height)
//        }
    }
}
