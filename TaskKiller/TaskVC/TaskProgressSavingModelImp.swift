//
//  TaskInfoGetableFacade.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskProgressSavingModelImp: TaskProgressSavingModel {

    
    
    private let task: Task
    private var timeSpentInProgress: TimeInterval {
        return task.getTimeSpentInProgress()
    }
    private var deadLine: TimeInterval {
        return task.getCurrentDeadline()
    }
    //MARK: TimeLeftToDeadlineGetable
    var timeLeftToDeadLine: TimeLeftToDeadLine {
        return TimeLeftToDeadLine.init(timeLeftToDeadLine: deadLine - timeSpentInProgress)
    }
    
    //MARK:TaskHandling
    init(task: Task) {
        self.task = task
    }
    
    //MARK: TaskStaticInfoSource
    var staticInfo: TaskStaticInfo {
        let taskDescription = task.getTaskDescription()
        let deadLine = task.getInitialDeadline()
        let tags = task.getTags()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: deadLine, tags: tags)
    }
    
    //MARK: TaskProgressSaving
    func saveTaskProgressPeriod(_ period: ProgressPeriod) {
        task.saveProgressPeriod(period)
    }
    //MARK: ProgressTimesSource
    var progressTimes: TaskProgressTimes {
        let progressTimes = TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, timeLeftToDeadLine: timeLeftToDeadLine)
        return progressTimes
    }
    
    func postponeDeadlineFor(_ timeInterval: TimeInterval) {
        task.postponeDeadlineFor(timeInterval)
    }
}
