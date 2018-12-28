//
//  TagView.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UIKit


class TagView: UIView, TagInfoSetable {
    
    //MARK: Appearance constants
    private var tagViewBackgroundColor = UIColor.clear
    private var cornerRadius: CGFloat = 10
    private var nameFontSize: CGFloat = 17 {
        didSet {
            updateNameLabel()
        }
    }
    private let normalSizeCellFontSize: CGFloat = 17
    private let largeSizeCellFontSize: CGFloat = 25
    private var nameFont: UIFont {
        return UIFont.systemFont(ofSize: nameFontSize)
    }
    private var paddingAroundNameLabel: CGFloat {
        return cornerRadius / 2
    }
    private var tagColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    private var tagName: String = "" {
        didSet {
            updateNameLabel()
        }
    }
    
    private var nameLabel: UILabel!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupTagView()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        tagColor.setFill()
        path.fill()
    }
    
    //MARK: TagInfoSetable
    func setTagInfo(_ tag: Tag) {
        setTagName(tag.getName())
        setTagColor(tag.getColor())
    }
    
    func getEstimatedTagViewSize() -> CGSize {
        let width = nameLabel.getWidth() + cornerRadius
        let height = nameLabel.getHeight() + cornerRadius
        return CGSize(width: width, height: height)
    }
    func changeSizeToLarge() {
        setFontSize(largeSizeCellFontSize)
    }
    func changeSizeToNormal() {
        setFontSize(normalSizeCellFontSize)
    }
}

extension TagView {
    
    private func updateNameLabel() {
        nameLabel.setText(tagName)
        nameLabel.font = nameFont
        nameLabel.sizeToFit()
    }
    //MARK: set tag name and color
    private func setTagName(_ tagName: String) {
        self.tagName = tagName
    }
    private func setTagColor(_ tagColor: UIColor) {
        self.tagColor = tagColor
    }
    private func setFontSize(_ newFontSize: CGFloat) {
        self.nameFontSize = newFontSize
    }
    
    //MARK: setupTagView
    private func setupTagView() {
        setupNameLabel()
        setBackgroundColor()
    }
    private func setupNameLabel() {
        self.nameLabel = UILabel()
        nameLabel.setText(tagName)
        nameLabel.font = nameFont
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        constraintNameLabelToTagView()
    }
    private func constraintNameLabelToTagView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -paddingAroundNameLabel).isActive = true
        self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: paddingAroundNameLabel).isActive = true
        self.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -paddingAroundNameLabel).isActive = true
        self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: paddingAroundNameLabel).isActive = true
    }
    private func setBackgroundColor() {
        backgroundColor = tagViewBackgroundColor
        isOpaque = false
    }
    
    
}

