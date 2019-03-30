//
//  TagView.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UIKit


class TagView: UIView {
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
            nameLabel.sizeToFit()
        }
    }
    var color: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var nameLabel: UILabel!
    
    //MARK: Appearance
    private let cornerRadius: CGFloat = 10
    private var paddingAroundNameView: CGFloat {
        return cornerRadius / 2
    }
    private var font = UIFont.systemFont(ofSize: 17)
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        color.setFill()
        path.fill()
    }
    
    func getEstimatedTagViewSize() -> CGSize {
        let width = nameLabel.getWidth() + 2 * paddingAroundNameView
        let height = nameLabel.getHeight() + 2 * paddingAroundNameView
        return CGSize(width: width, height: height)
    }
}

extension TagView {
    
    //MARK: setupTagView
    private func setupView() {
        setupNameLabel()
        backgroundColor = UIColor.clear
        isOpaque = false
    }
    
    private func setupNameLabel() {
        self.nameLabel = UILabel()
        nameLabel.font = font
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -paddingAroundNameView).isActive = true
        self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: paddingAroundNameView).isActive = true
        self.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -paddingAroundNameView).isActive = true
        self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: paddingAroundNameView).isActive = true
    }
}

