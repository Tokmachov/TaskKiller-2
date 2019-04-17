//
//  TaskListTagCollectionFlowLayout.swift
//  TaskKiller
//
//  Created by mac on 11/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskListTagCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        sectionInset = TaskListTagCollectionFlowLayout.Constants.sectionInsets
        sectionInsetReference = .fromSafeArea
        minimumLineSpacing = 5
        scrollDirection = .horizontal
        estimatedItemSize = CGSize(width: 10, height: 10)
    }
}

extension TaskListTagCollectionFlowLayout {
    enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
    }
}
