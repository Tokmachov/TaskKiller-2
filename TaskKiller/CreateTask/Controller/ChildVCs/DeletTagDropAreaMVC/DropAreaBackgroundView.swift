//
//  DeleteDropareaBackgroundView.swift
//  TaskKiller
//
//  Created by mac on 08/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DropAreaBackgroundView: UIView {
    var circleColor = UIColor.red
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(ovalIn: rect)
        circleColor.setFill()
        path.fill()
    }
}
