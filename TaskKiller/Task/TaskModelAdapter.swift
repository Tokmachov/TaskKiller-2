//
//  TaskModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskModelAdapter: Task {
 
    private var adaptee: TaskModel
    init(task: TaskModel) {
        self.adaptee = task
    }
    func getTaskDescription() -> String {
        return self.adaptee.taskDescription!
    }
    func getInitialDeadLine() -> TimeInterval {
        return TimeInterval(adaptee.deadLine)
    }
    func getPostponableDeadLine() -> TimeInterval {
        return TimeInterval(adaptee.postponableDeadLine)
    }
    
    func getTimeSpentInProgress() -> TimeInterval {
        return TimeInterval(adaptee.timeSpentInProgress)
    }
    
   
    func saveProgress(progressTimes: TaskProgressTimes, taskProgressPeriod: TaskProgressPeriod) {
        let timeSpentInProgress = Int16(progressTimes.timeSpentInprogress)
        let postponableDeadline = Int16(progressTimes.currentDeadLine)
        let period = createPeriodModel(from: taskProgressPeriod)
        adaptee.timeSpentInProgress = timeSpentInProgress
        adaptee.postponableDeadLine = postponableDeadline
        adaptee.addToPeriodsOfProcess(period)
        PersistanceService.saveContext()
    }
    func addTags(_ tags: AllTagsGetableStore) {
        let tagArray = tags.getAllTags()
        let tagModels = NSOrderedSet(array: tagArray.map({ $0.getTagModel() }))
        adaptee.addToTags(tagModels)
        PersistanceService.saveContext()
    }
}

extension TaskModelAdapter {
    private func createPeriodModel(from taskProgressPeriod: TaskProgressPeriod) -> PeriodModel {
        let period = PeriodModel(context: PersistanceService.context)
        let dateStarted = taskProgressPeriod.dateStarted as NSDate
        let dateFinished = taskProgressPeriod.dateEnded as NSDate
        period.dateStarted = dateStarted
        period.dateFinished = dateFinished
        return period
    }
}
