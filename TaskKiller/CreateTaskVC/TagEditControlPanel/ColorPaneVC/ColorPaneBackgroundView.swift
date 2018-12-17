//
//  ColorPaneBackgroundView.swift
//  TaskKiller
//
//  Created by mac on 16/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPaneBackgroundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var paneColor: UIColor = UIColor.green
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        paneColor.withAlphaComponent(0.5)
        paneColor.setFill()
        
        path.fill()
    }
}
