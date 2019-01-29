//
//  TaskInfoGetableModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation



struct InfoGetableTaskHandlerImp: InfoGetableTaskHandler {

    private let task: Task
    
    private var timeLeftToDeadLine: TimeLeftToDeadLine {
        switch (task.getDeadLine(), task.getTimeSpentInProgress()) {
        case let (deadLine, spentInProgress) where deadLine > spentInProgress: return .timeLeft(deadLine - spentInProgress)
        case let (deadLine, spentInProgress) where deadLine <= spentInProgress: return .noTimeLeft
        default: return .noTimeLeft
        }
    }
    
    private var timeSpentInProgress: TimeInterval {
        return task.getTimeSpentInProgress()
    }
    
    //MARK: TaskHandling
    init(task: Task) {
        self.task = task
    }
    
    //MARK: TaskProgressTimesCreating
    func createProgressTimes() -> TaskProgressTimes {
        let progressTimes = TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, timeLeftToDeadLine: timeLeftToDeadLine)
        return progressTimes
    }
    
    //MARK: TaskStaticInfoCreating
    func createStaticInfo() -> TaskStaticInfo {
        let taskDescription = task.getTaskDescription()
        let initialDeadline = task.getDeadLine()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: initialDeadline)
    }
}
