//
//  ColorSelectionButton.swift
//  TaskKiller
//
//  Created by mac on 16/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

@IBDesignable

class ColorSelectionButton: UIButton {
    
    @IBInspectable var color: UIColor = UIColor.green
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: bounds)
        color.setFill()
        path.fill()
    }
}
