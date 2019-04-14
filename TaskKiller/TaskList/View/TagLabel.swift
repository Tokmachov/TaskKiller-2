//
//  NewLabel.swift
//  TaskKiller
//
//  Created by mac on 13/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TagLabel: UILabel {
    var tagColor: UIColor! { didSet { backgroundColor = tagColor } }
    var tagName: String! {
        didSet {
            text = tagName
        }
    }
    private var borderWidth: CGFloat = 2
    private var borderColor: UIColor = UIColor.black
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }

    private func setupLabel() {
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        textAlignment = .center
        layer.masksToBounds = true
    }
    override var intrinsicContentSize: CGSize {
        var intrinsicContentsSize = super.intrinsicContentSize
        intrinsicContentsSize.width *= 1.5
        intrinsicContentsSize.height *= 1.5
        return intrinsicContentsSize
    }
    
    
}
