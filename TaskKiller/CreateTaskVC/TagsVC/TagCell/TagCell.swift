//
//  TagCell.swift
//  TaskKiller
//
//  Created by mac on 20/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell, TagInfoSetable {
    
    private var tagView = TagView()
    private var cellBackgroundColor = UIColor.clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: TagInfoSetable
    func setTagInfo(_ tag: Tag) {
        tagView.setTagInfo(tag)
    }
    
    func getSizeNeededForContentView() -> CGSize {
        return tagView.getEstimatedTagViewSize()
    }
}

extension TagCell {
    private func setupView() {
        addSubview(tagView)
        constraintTagViewToContentView()
        setCellBackgroundColor()
    }
    private func constraintTagViewToContentView() {
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tagView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    private func setCellBackgroundColor() {
        backgroundColor = cellBackgroundColor
    }
    
}

