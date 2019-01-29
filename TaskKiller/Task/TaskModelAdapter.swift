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
    func getTimeSpentInProgress() -> TimeInterval {
        guard let periods = adaptee.periodsOfProcess?.allObjects as? [PeriodModel] else { return TimeInterval(adaptee.deadLine) }
        let timeSpentInProgress = getDurationOfPeriods(periods)
        return timeSpentInProgress
    }
    func getDeadLine() -> TimeInterval {
        return TimeInterval(adaptee.deadLine)
    }
 
    func saveTaskProgressPeriod(_ period: TaskProgressPeriod) {
        let period = createPeriodModel(from: period)
        adaptee.addToPeriodsOfProcess(period)
        PersistanceService.saveContext()
    }
    
    private func getDurationOfPeriods(_ periods: [PeriodModel]) -> TimeInterval {
        var durationOfPeriods: TimeInterval = 0
        for period in periods {
            let dateStarted = period.dateStarted! as Date
            let dateFinished = period.dateFinished! as Date
            let periodTime = dateFinished.timeIntervalSince(dateStarted)
            durationOfPeriods += periodTime
        }
        return durationOfPeriods
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
