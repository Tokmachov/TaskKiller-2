//
//  TagCellConfiguring.swift
//  TaskKiller
//
//  Created by mac on 02/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
protocol TagCellConfiguring {
    func configure(tagCell: TagCell, withTag tag: Tag)
}

extension TagCellConfiguring {
    func configure(tagCell: TagCell, withTag tag: Tag) {
        tagCell.name = tag.name
        tagCell.color = tag.color
        tagCell.adaptTagCornerRadiusToCellHeight()
    }
}
