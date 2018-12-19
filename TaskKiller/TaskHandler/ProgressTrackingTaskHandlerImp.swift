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
    
    //MARK:TaskHandling
    init(taskModelFacade: Task) {
        self.task = taskModelFacade
    }
    
    //MARK: TaskStaticInfoGetable
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = task.getTaskDescription()
        let deadLine = task.getInitialDeadLine()
        
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: deadLine)
    }
    
    //MARK: TaskProgressTimesGetable
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInProgress = task.getTimeSpentInProgress()
        let postponableDeadLines = task.getPostponableDeadLine()
        return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: postponableDeadLines)
    }
    
    //MARK: TaskProgressSaving
    func saveTaskProgress(progressInfoSource: TaskProgressInfoGetable) {
        let progressInfo = progressInfoSource.getProgressInfo()
        let progressTimes = progressInfo.progressTimes
        let progressPeriod = progressInfo.progressPeriod
        task.saveProgress(progressTimes: progressTimes, taskProgressPeriod: progressPeriod)
    }
}
