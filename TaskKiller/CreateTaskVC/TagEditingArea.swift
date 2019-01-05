//
//  TagEditingArea.swift
//  TaskKiller
//
//  Created by mac on 03/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
struct TagEditingAreaSetups {
    static var alpha: CGFloat = 0.5
    static var backgroundColor = UIColor.green
}
class TagEditingArea: UIView {
    let customColorForBackGround = UIColor.white
    let customAlpha: CGFloat = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TagEditingArea {
    func setupView() {
        backgroundColor = TagEditingAreaSetups.backgroundColor.withAlphaComponent(TagEditingAreaSetups.alpha)
    }
}
