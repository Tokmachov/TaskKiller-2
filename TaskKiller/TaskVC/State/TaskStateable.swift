//
//  TaskStateable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStatable {
    
    init(taskProgressTimes: TaskProgressTimes, postponableDeadLineChangesReceiver: PostponableDeadlineChangesReceiving, currentTimeSpentInProgressReceiver: CurrentTimeSpentInProgressReceiving)
    
    mutating func incrementTimeSpentInProcess(by increment: TimeInterval)
    mutating func setPostponableDeadLine(_ deadLine: TimeInterval)
    mutating func changeState()
    func getCurrentState() -> States
    func getCurrentTimeSpentInProgress() -> TimeInterval
}
