//
//  TagsAddedToTaskCollectionLayout.swift
//  TaskKiller
//
//  Created by mac on 02/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsAddedToTaskCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 5
        sectionInsetReference = .fromSafeArea
        scrollDirection = .horizontal
    }
}
