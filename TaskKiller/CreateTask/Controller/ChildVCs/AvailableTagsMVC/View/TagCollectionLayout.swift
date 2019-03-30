//
//  TagCollectionFlowLayout.swift
//  TaskKiller
//
//  Created by mac on 30/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagCollectionLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        guard collectionView != nil else { return }
        minimumLineSpacing = 5
        minimumInteritemSpacing = 10
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        sectionInsetReference = .fromContentInset
    }
}
