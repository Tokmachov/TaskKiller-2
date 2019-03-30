//
//  TagCollectionBackGroundView.swift
//  TaskKiller
//
//  Created by mac on 30/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagCollectionBackgroundView: UIView {
    private let cornerRadius: CGFloat = 30
    private let colorForBackground = UIColor.clear
    private let colorForOutline = UIColor.blue
    private let lineWidth: CGFloat = 2
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let outlinePath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        outlinePath.lineWidth = lineWidth
        colorForOutline.setStroke()
        
        outlinePath.stroke()
    }
    private func setupView() {
        backgroundColor = colorForBackground
        isOpaque = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
