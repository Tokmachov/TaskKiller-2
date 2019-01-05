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
    
    private var nameView: TagNameLabel!
    
    //MARK: Appearance
    private let cornerRadius: CGFloat = 10
    private var paddingAroundNameView: CGFloat {
        return cornerRadius / 2
    }
    private var tagColor = UIColor.gray
    
    private let normalFontSize: CGFloat = 17
    private let largeFontSize: CGFloat = 25
    
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
    func setSize(_ size: SizeOfTagView) {
        switch size {
        case .normal: nameView.setFontSize(normalFontSize)
        case .large: nameView.setFontSize(largeFontSize)
        }
    }
    func getEstimatedTagViewSize() -> CGSize {
        let width = nameView.getWidth() + 2 * paddingAroundNameView
        let height = nameView.getHeight() + 2 * paddingAroundNameView
        return CGSize(width: width, height: height)
    }
}

extension TagView {
    
    private func setTagColor(_ color: UIColor) {
        tagColor = color
        setNeedsDisplay()
    }
    private func setTagName(_ name: String) {
        nameView.setName(name)
    }
    
    //MARK: setupTagView
    private func setupView() {
        setupNameView()
        setBackgroundColor()
    }
    private func setupNameView() {
        self.nameView = TagNameLabel()
        addSubview(nameView)
        constraintNameViewToTagView()
    }
    private func constraintNameViewToTagView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: -paddingAroundNameView).isActive = true
        self.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: paddingAroundNameView).isActive = true
        self.topAnchor.constraint(equalTo: nameView.topAnchor, constant: -paddingAroundNameView).isActive = true
        self.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: paddingAroundNameView).isActive = true
    }
    private func setBackgroundColor() {
        backgroundColor = UIColor.clear
        isOpaque = false
    }
}

