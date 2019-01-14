//
//  TagStore.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TagStore {
    var count: Int { get }
    mutating func remove(_ tag: Tag)
    mutating func add(_ tag: Tag)
    mutating func move(from sourceIndex: Int, to destinationIndex: Int)
    func getTag(at index: Int) -> Tag
    func canAdd(_ tag: Tag) -> Bool
}
