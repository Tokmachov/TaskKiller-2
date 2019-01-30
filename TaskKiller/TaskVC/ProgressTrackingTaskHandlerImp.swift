//
//  TaskInfoGetableFacade.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct ProgressTrackingTaskHandlerImp: ProgressTrackingTaskHandler {
    
    private let task: Task
    private var timeSpentInProgress: TimeInterval {
        return task.getTimeSpentInProgress()
    }
    private var deadLine: TimeInterval {
        return task.getDeadLine()
    }
    private var timeLeftToDeadLine: TimeLeftToDeadLine {
        switch (timeSpentInProgress, deadLine) {
        case let (timeSpent, deadLine) where timeSpent < deadLine:
            let timeLeft = deadLine - timeSpent
            return TimeLeftToDeadLine.timeLeft(timeLeft)
        case let (timeSpent, deadLine) where timeSpent >= deadLine:
            return TimeLeftToDeadLine.noTimeLeft
        default: return TimeLeftToDeadLine.noTimeLeft
        }
    }
    
    //MARK:TaskHandling
    init(task: Task) {
        self.task = task
    }
    
    //MARK: TaskStaticInfoGetable
    func createStaticInfo() -> TaskStaticInfo {
        let taskDescription = task.getTaskDescription()
        let deadLine = task.getDeadLine()
        let tags = task.getTags()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: deadLine, tags: tags)
    }
    
    //MARK: TaskProgressSaving
    func saveTaskProgressPeriod(_ period: TaskProgressPeriod) {
        task.saveTaskProgressPeriod(period)
    }
    
    //MARK: ProgressCreating
    func createProgressTimes() -> TaskProgressTimes {
        let progressTimes = TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, timeLeftToDeadLine: timeLeftToDeadLine)
        return progressTimes
    }
}
