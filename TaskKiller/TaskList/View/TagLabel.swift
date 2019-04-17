//
//  NewLabel.swift
//  TaskKiller
//
//  Created by mac on 13/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TagLabel: UILabel {

    private let borderWidth: CGFloat = 2
    private let borderColor: UIColor = UIColor.black
    
    var color: UIColor! { didSet { backgroundColor = color } }
    var name: String! { didSet { text = name } }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    private func setupLabel() {
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        textAlignment = .center
        layer.masksToBounds = true
        font = UIFont.preferredFont(forTextStyle: .body)
    }
    func adaptCornerRadiusToLabelHeight() {
        layer.cornerRadius = intrinsicContentSize.height / 2
    }
    override var intrinsicContentSize: CGSize {
        var intrinsicContentsSize = super.intrinsicContentSize
        intrinsicContentsSize.width *= 1.5
        intrinsicContentsSize.height *= 1.5
        return intrinsicContentsSize
    }
}

