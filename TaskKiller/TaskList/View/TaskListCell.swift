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
    
    var taskDescription: String! { didSet { taskDescriptionLabel.text = taskDescription } }
    var cellIndex: Int! {
        didSet {
            tagsCollectionView.tag = cellIndex
            tagsCollectionView.reloadData()
        }
    }
    
    func adjustTagCollectionViewHeight(to tagHeight: CGFloat) {
        tagCollectionViewHeightConstraint.constant =
            TaskListTagCollectionFlowLayout.Constants.sectionInsets.top +
            TaskListTagCollectionFlowLayout.Constants.sectionInsets.bottom +
            tagHeight
    }
}







