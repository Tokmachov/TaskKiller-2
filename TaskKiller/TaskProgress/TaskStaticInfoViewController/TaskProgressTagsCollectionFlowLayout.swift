//
//  TaskProgressTagsCollectionFlowLayout.swift
//  TaskKiller
//
//  Created by mac on 20/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskProgressTagsCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        sectionInset = TaskProgressTagsCollectionFlowLayout.Constants.sectionInsets
        sectionInsetReference = .fromSafeArea
        minimumLineSpacing = 5
        scrollDirection = .horizontal
        estimatedItemSize = CGSize(width: 10, height: 10)
    }
}

extension TaskProgressTagsCollectionFlowLayout {
    enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
    }
}
