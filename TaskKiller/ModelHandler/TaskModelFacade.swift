//
//  TaskModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskModelFacade: ITaskModelFacade {
 
    private var taskModel: TaskModel
    init(task: TaskModel) {
        self.taskModel = task
    }
    func getTaskDescription() -> String {
        return self.taskModel.taskDescription!
    }
    func getInitialDeadLine() -> TimeInterval {
        return TimeInterval(taskModel.deadLine)
    }
    func getPostponableDeadLine() -> TimeInterval {
        return TimeInterval(taskModel.postponableDeadLine)
    }
    
    func getTimeSpentInProgress() -> TimeInterval {
        return TimeInterval(taskModel.timeSpentInProgress)
    }
    
   
    func saveProgress(progressTimes: TaskProgressTimes, taskProgressPeriod: TaskProgressPeriod) {
        let timeSpentInProgress = Int16(progressTimes.timeSpentInprogress)
        let postponableDeadline = Int16(progressTimes.currentDeadLine)
        let period = createPeriodModel(from: taskProgressPeriod)
        taskModel.timeSpentInProgress = timeSpentInProgress
        taskModel.postponableDeadLine = postponableDeadline
        taskModel.addToPeriodsOfProcess(period)
        PersistanceService.saveContext()
    }
}

extension TaskModelFacade {
    private func createPeriodModel(from taskProgressPeriod: TaskProgressPeriod) -> PeriodModel {
        let period = PeriodModel(context: PersistanceService.context)
        let dateStarted = taskProgressPeriod.dateStarted as NSDate
        let dateFinished = taskProgressPeriod.dateEnded as NSDate
        period.dateStarted = dateStarted
        period.dateFinished = dateFinished
        return period
    }
}
