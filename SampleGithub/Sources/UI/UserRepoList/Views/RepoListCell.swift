//
//  RepoListCell.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/30.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import API

final class RepoListCell: UITableViewCell {

    typealias Entity = Repo

    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            nameLabel.textColor = UIColor(red:0.012, green:0.399, blue:0.837, alpha:1)
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            descriptionLabel.textColor = UIColor.gray
        }
    }
    @IBOutlet private weak var languageLabel: UILabel! {
        didSet {
            languageLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
    }
    @IBOutlet private weak var starsLabel: UILabel! {
        didSet {
            starsLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
    }
    @IBOutlet private weak var forksLabel: UILabel! {
        didSet {
            forksLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ entity: Entity) {
        nameLabel.text = entity.name
        descriptionLabel.text = entity.description
        starsLabel.text = "\(entity.stargazersCount)"
        forksLabel.text = "\(entity.forksCount)"
        languageLabel.text = "\(entity.language ?? "")"
    }
}
