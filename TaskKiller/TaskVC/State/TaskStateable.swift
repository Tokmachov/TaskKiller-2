//
//  TaskStateable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStatable {
    
    init(taskProgressTimes: TaskProgressTimes)
    
    mutating func updateTimeSpentInProgress(_ newTime: TimeInterval)
    mutating func postponeDeadLine(for time: TimeInterval)
    mutating func changeState()
    func getCurrentState() -> States
}
