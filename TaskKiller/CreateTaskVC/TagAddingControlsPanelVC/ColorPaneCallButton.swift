//
//  ColorPaneCallButton.swift
//  TaskKiller
//
//  Created by mac on 17/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class ColorPaneCallButton: UIButton {
    private var chosenColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    func setChosenColor(_ color: UIColor) {
        self.chosenColor = color
    }
    override func draw(_ rect: CGRect) {
        let colorDotPath = UIBezierPath(ovalIn: bounds)
        chosenColor.setFill()
        colorDotPath.fill()
    }
}
