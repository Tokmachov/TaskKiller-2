//
//  TaskModelCreating.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskModelCreating {
    init()
    mutating func createTask(from taskStaticInfo: TaskStaticInfo)
}
