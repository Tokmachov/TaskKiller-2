//
//  TaskStateable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskState {
    init(stateSavingDelegate: TaskStateDelegate)
    mutating func goToNextState()
    mutating func goToStartedState()
    mutating func goToStoppedState()
}


