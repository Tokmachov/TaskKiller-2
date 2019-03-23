//
//  TagDummyView.swift
//  TaskKiller
//
//  Created by mac on 10/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagDummyView: UIView, TagInfoSetable {
    private let cornerRadius: CGFloat = 40
    private var tagColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBOutlet var nameLabel: TagNameLabel!
    
    func setTagInfo(_ tag: Tag) {
        nameLabel.setName(tag.name)
        tagColor = tag.color
    }
    func setTagName(_ name: String) {
        nameLabel.setName(name)
    }
    func setTagColor(_ color: UIColor) {
        tagColor = color
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        tagColor.setFill()
        path.fill()
    }
}
