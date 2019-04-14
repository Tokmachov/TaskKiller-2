//
//  TagCell.swift
//  TaskKiller
//
//  Created by mac on 20/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: TagLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    var tagName: String {
        set {
            tagLabel.tagName = newValue
        }
        get {
            return tagLabel.tagName
        }
    }
    var tagColor: UIColor {
        set {
            tagLabel.tagColor = newValue
        }
        get {
            return tagLabel.tagColor
        }
    }
}
