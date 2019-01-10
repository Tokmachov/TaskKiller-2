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
    
    private var nameLabel: TagNameLabel! 
    
    //MARK: Appearance
    private let cornerRadius: CGFloat = 10
    private var paddingAroundNameView: CGFloat {
        return cornerRadius / 2
    }
    private var tagColor = UIColor.gray
    private let tagNameFontSize: CGFloat = 17
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
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
    func setTagNameFontSize(_ size: CGFloat) {
        nameLabel.setFontSize(size)
    }
    func getEstimatedTagViewSize() -> CGSize {
        let width = nameLabel.getWidth() + 2 * paddingAroundNameView
        let height = nameLabel.getHeight() + 2 * paddingAroundNameView
        return CGSize(width: width, height: height)
    }
}

extension TagView {
    
    private func setTagColor(_ color: UIColor) {
        tagColor = color
        setNeedsDisplay()
    }
    private func setTagName(_ name: String) {
        nameLabel.setName(name)
    }
    
    //MARK: setupTagView
    private func setupView() {
        setupNameView()
        setBackgroundColor()
    }
    private func setupNameView() {
        self.nameLabel = TagNameLabel()
        addSubview(nameLabel)
        constraintNameViewToTagView()
        nameLabel.setFontSize(tagNameFontSize)
    }
    private func constraintNameViewToTagView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -paddingAroundNameView).isActive = true
        self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: paddingAroundNameView).isActive = true
        self.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -paddingAroundNameView).isActive = true
        self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: paddingAroundNameView).isActive = true
    }
    private func setBackgroundColor() {
        backgroundColor = UIColor.clear
        isOpaque = false
    }
}

