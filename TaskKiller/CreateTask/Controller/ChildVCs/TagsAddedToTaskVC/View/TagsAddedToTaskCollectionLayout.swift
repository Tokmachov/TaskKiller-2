//
//  TagsAddedToTaskCollectionLayout.swift
//  TaskKiller
//
//  Created by mac on 02/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

import UIKit

class TagsAddedToTaskCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        sectionInset = TagsAddedToTaskCollectionFlowLayout.Constants.sectionInsets
        sectionInsetReference = .fromSafeArea
        minimumLineSpacing = 5
        scrollDirection = .horizontal
        estimatedItemSize = CGSize(width: 10, height: 10)
    }
}

extension TagsAddedToTaskCollectionFlowLayout {
    enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
    }
}
