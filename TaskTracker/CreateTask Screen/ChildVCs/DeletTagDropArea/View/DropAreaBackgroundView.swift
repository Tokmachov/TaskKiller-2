//
//  DeleteDropareaBackgroundView.swift
//  TaskKiller
//
//  Created by mac on 08/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DropAreaBackgroundView: UIView {
    var backGroundColor = UIColor.red
    private let cornerRadius: CGFloat = 20
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        backGroundColor.setFill()
        path.fill()
    }
}
