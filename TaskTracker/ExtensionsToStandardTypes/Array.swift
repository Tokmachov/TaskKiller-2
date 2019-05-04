//
//  ArrayExtensions.swift
//  TaskKiller
//
//  Created by mac on 11/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

extension Array {
    func reorderedByMovement(from sourceIndex: Int, to destinationIndex: Int) -> [Element] {
        var outputArray = self
        let elementToMove = self[sourceIndex]
        outputArray.remove(at: sourceIndex)
        outputArray.insert(elementToMove, at: destinationIndex)
        return outputArray
    }
}
