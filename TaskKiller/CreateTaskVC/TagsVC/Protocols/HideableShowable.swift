//
//  HideableShowable.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol HideableShowable {
    func show()
    func hide()
}
extension HideableShowable where Self: UIView {
    func show() {
        isHidden = false
    }
    func hide() {
        isHidden = true
    }
}
extension UIView: HideableShowable {}
