//
//  TaskCell.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView! 
    @IBOutlet weak var tagCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var taskDescription: String! {
        didSet { taskDescriptionLabel.text = taskDescription }
    }
    var cellIndex: Int! {
        didSet { tagsCollectionView.tag = cellIndex }
    }
    func adjustTagCollectionViewHeight(to tagHeight: CGFloat) {
        let insets = getTagCollectionInset()
        tagCollectionViewHeightConstraint.constant = insets.top + insets.bottom +
        tagHeight * 1.3
        
    }
    private func getTagCollectionInset() -> UIEdgeInsets {
        return (tagsCollectionView.collectionViewLayout as! TaskListTagCollectionFlowLayout).sectionInset
    }
}







