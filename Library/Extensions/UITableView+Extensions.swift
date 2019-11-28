//
//  UITableView+Extensions.swift
//  Library
//
//  Created by Kosuke Matsuda on 2019/11/29.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    public func registerNib<T: UITableViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }

    public func registerClass<T: UITableViewCell>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        register(T.self, forCellReuseIdentifier: identifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = T.reusableIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(identifier).")
        }
        return cell
    }

    public func registerNib<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func registerClass<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = T.reusableIdentifier
        register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        let identifier = T.reusableIdentifier
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Could not dequeue HeaderFooterView: \(T.self) with identifier: \(identifier).")
        }
        return view
    }
}
