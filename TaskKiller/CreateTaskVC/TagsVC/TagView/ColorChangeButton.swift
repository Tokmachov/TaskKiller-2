//
//  ColorChangeButton.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit



class ColorChangeButton: UIButton  {
    
    @IBOutlet weak var aspectConstraint: NSLayoutConstraint!
    @IBInspectable var rimColor: UIColor = UIColor.white
    @IBInspectable var rimWidth: CGFloat = 4
    
    private weak var delegate: ColorButtonActionReceiving!
    private var colorDotColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var dotCenter: CGPoint {
        return CGPoint(x: bounds.maxX / 2, y: bounds.maxY / 2)
    }
    private var colorDotRadius: CGFloat {
        return min(bounds.maxX, bounds.maxY) / 2 - rimWidth
    }
    
    override func draw(_ rect: CGRect) {
        let colorDotCircul = UIBezierPath(arcCenter: dotCenter, radius: colorDotRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        colorDotCircul.lineWidth = rimWidth
        colorDotColor.setFill()
        rimColor.setStroke()
        colorDotCircul.fill()
        colorDotCircul.stroke()
    }
    
    func setColorDotColor(_ color: UIColor) {
        colorDotColor = color
    }
    func setDelegate(_ delegate: ColorButtonActionReceiving) {
        self.delegate = delegate
    }
    
    //MARK: HideableShowableView
    func hide() {
        guard aspectConstraint != nil else { return }
        aspectConstraint.isActive = false
        self.isHidden = true
    }
    func show() {
        guard aspectConstraint == nil else { return }
        self.isHidden = false
        aspectConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        aspectConstraint.isActive = true
    }
}
