//
//  TaskInfoGetableFacade.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskProgressTrackingModelHandler: ITaskProgressTrackingModelHandler {
    
    private let taskModelFacade: ITaskModelFacade
    
    //MARK:TaskHandling
    init(taskModelFacade: ITaskModelFacade) {
        self.taskModelFacade = taskModelFacade
    }
    
    //MARK: TaskStaticInfoGetable
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = taskModelFacade.getTaskDescription()
        let deadLine = taskModelFacade.getInitialDeadLine()
        
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: deadLine)
    }
    
    //MARK: TaskProgressTimesGetable
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInProgress = taskModelFacade.getTimeSpentInProgress()
        let postponableDeadLines = taskModelFacade.getPostponableDeadLine()
        return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: postponableDeadLines)
    }
    
    //MARK: TaskProgressSaving
    func saveTaskProgress(progressInfoSource: TaskProgressInfoGetable) {
        let progressInfo = progressInfoSource.getProgressInfo()
        let progressTimes = progressInfo.progressTimes
        let progressPeriod = progressInfo.progressPeriod
        taskModelFacade.saveProgress(progressTimes: progressTimes, taskProgressPeriod: progressPeriod)
    }
}
