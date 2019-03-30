//
//  ColorSampleView.swift
//  TaskKiller
//
//  Created by mac on 28/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class ColorSampleView: UIView {
    var chosenColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(ovalIn: rect)
        chosenColor.setFill()
        path.fill()
    }
}
