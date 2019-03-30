//
//  TagDummyView.swift
//  TaskKiller
//
//  Created by mac on 10/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagDummyView: UIView {
    private let cornerRadius: CGFloat = 40
    private var tagColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBOutlet var nameLabel: UILabel!
    
    func setTagInfo(_ tag: Tag) {
        nameLabel.text = tag.name
        tagColor = tag.color
    }
    func setTagName(_ name: String) {
        nameLabel.text = name
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
