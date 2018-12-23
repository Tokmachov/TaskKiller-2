//
//  TagView.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TagView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    private var tagColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    private var name: String = ""
    
    private var nameFontSize: CGFloat = 17
    private var nameFont: UIFont {
        return UIFont.systemFont(ofSize: nameFontSize)
    }
    private var tagViewNameLabelPadding: CGFloat {
        return cornerRadius / 2
    }
    private var nameLabel: UILabel!
    
    
    convenience init(tag: Tag) {
        self.init(frame: CGRect.zero)
        setTagName(tag.getName())
        setTagColor(tag.getColor())
        setupNameLabel()
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        isOpaque = false
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        tagColor.setFill()
        path.fill()
    }
    
    func getEstimatedTagViewSize() -> CGSize {
        let width = nameLabel.getWidth() + cornerRadius
        let height = nameLabel.getHeight() + cornerRadius
        return CGSize(width: width, height: height)
    }
}

extension TagView {
    private func setTagName(_ tagName: String) {
        self.name = tagName
    }
    private func setTagColor(_ tagColor: UIColor) {
        self.tagColor = tagColor
    }
    
    private func setupNameLabel() {
        self.nameLabel = UILabel()
        nameLabel.setText(name)
        nameLabel.font = nameFont
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        constraintNameLabelToTagView()
    }
    private func constraintNameLabelToTagView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: tagViewNameLabelPadding).isActive = true
        self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: tagViewNameLabelPadding).isActive = true
        self.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: tagViewNameLabelPadding).isActive = true
        self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: tagViewNameLabelPadding).isActive = true
    }
}

