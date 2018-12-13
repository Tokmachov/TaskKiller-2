//
//  DeleteButton.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

@IBDesignable

class DeleteButton: UIButton {
    
    @IBOutlet weak var aspectConstraint: NSLayoutConstraint!
    
    weak var delegate: DeletButtonActionReceiving!
    @IBInspectable var circleFillColor: UIColor = UIColor.gray
    @IBInspectable var crossColor: UIColor = UIColor.gray
    @IBInspectable var crossLineWidth: CGFloat = 2
    @IBInspectable var crossRadius: CGFloat = 5
    
    private var buttonRadius: CGFloat {
        return min(bounds.maxX, bounds.maxY) / 2
    }
    private var buttonCirculCenter: CGPoint {
        return CGPoint(x: bounds.maxX / 2, y: bounds.maxY / 2)
    }
    
    override func draw(_ rect: CGRect) {
        drawBackGroundDeleteButtonDot()
        drawDeleteCrossClippingArea()
        drawDeleteCross()
    }
    
    func setDelegate(_ delegate: DeletButtonActionReceiving) {
        self.delegate = delegate
    }
    //MARK: HideableShowAbleView
    func hide() {
        guard aspectConstraint != nil else { return }
        aspectConstraint.isActive = false
        self.isHidden = true
    }
    func show() {
        guard aspectConstraint == nil else { return }
        aspectConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        aspectConstraint.isActive = true
        self.isHidden = false
    }
}

extension DeleteButton {
    private func drawBackGroundDeleteButtonDot() {
        let buttonCircule = UIBezierPath(arcCenter: buttonCirculCenter, radius: buttonRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circleFillColor.setFill()
        buttonCircule.fill()
    }
    private func drawDeleteCross() {
        let deleteCrossPath = UIBezierPath()
        let rightDownPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
        let rightUpPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
        let leftDownPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
        deleteCrossPath.move(to: bounds.origin)
        deleteCrossPath.addLine(to: rightDownPoint)
        deleteCrossPath.move(to: rightUpPoint)
        deleteCrossPath.addLine(to: leftDownPoint)
        deleteCrossPath.lineWidth = crossLineWidth
        UIColor.white.setStroke()
        deleteCrossPath.stroke()
    }
    private func drawDeleteCrossClippingArea() {
        let path = UIBezierPath(arcCenter: buttonCirculCenter, radius: crossRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        UIColor.clear.setStroke()
        path.addClip()
        path.stroke()
    }
}

