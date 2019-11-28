//
//  UserListCell.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import API

final class UserListCell: UITableViewCell {

    typealias Entity = ListUser

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ entity: Entity) {
        usernameLabel.text = entity.login
        iconView.loadImage(with: entity.avatarUrl)
    }
}
