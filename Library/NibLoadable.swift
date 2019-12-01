//
//  NibLoadable.swift
//  Library
//
//  Created by Kosuke Matsuda on 2019/12/01.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
    var nibName: String { get }
    var bundle: Bundle { get }
    func loadFromNib(options: [UINib.OptionsKey: Any]?)
}

public extension NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }
    var nibName: String {
        return type(of: self).nibName
    }
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    func loadFromNib(options: [UINib.OptionsKey: Any]? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: options)
    }
}


// MARK: - NibLoadableView

public protocol NibLoadableView: NibLoadable {
    var contentView: UIView! { get }
    func loadContentViewFromNib()
}

public extension NibLoadableView where Self: UIView {
    func loadContentViewFromNib() {
        loadFromNib()
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}


// MARK: - UIView extension

extension UIView: NibLoadable {}
public extension NibLoadable where Self: UIView {
    static func loadNib() -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}
