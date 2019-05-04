//
//  UIViewControllerExtensions.swift
//  TaskKiller
//
//  Created by mac on 06/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildVC(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func removeChildVC(_ child: UIViewController) {
        guard child.parent != nil else { return }
        child.willMove(toParent: nil)
        child.removeFromParent()
    }
}
