//
//  UIViewExtensions.swift
//  TaskKiller
//
//  Created by mac on 23/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

extension UIView {
    func getWidth() -> CGFloat {
        return self.bounds.size.width
    }
    func getHeight() -> CGFloat {
        return self.bounds.size.height
    }
    
}

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

