//
//  UICollectionView.swift
//  TaskKiller
//
//  Created by mac on 03/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

extension UICollectionView {
    func lastIndexPath() -> IndexPath {
        let section = self.numberOfSections - 1
        let row = self.numberOfItems(inSection: section)
        return IndexPath(row: row, section: section)
    }
}
