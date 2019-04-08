//
//  TaskModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskImp: Task {
   
    private var taskModel: TaskModel
    init(task: TaskModel) {
        self.taskModel = task
    }
    var tagsStore: ImmutableTagStore {
        guard let tags = (taskModel.tags)?.array as? [Tag] else { return TagStoreImp(tags: [Tag]()) }
        let tagsStore = TagStoreImp(tags: tags)
        return tagsStore
    }
    func getTaskDescription() -> String {
        return self.taskModel.taskDescription!
    }
    func getTimeSpentInProgress() -> TimeInterval {
        guard let periods = taskModel.periodsOfProcess?.allObjects as? [PeriodModel] else { return TimeInterval(0) }
        let timeSpentInProgress = getDurationOfPeriods(periods)
        return timeSpentInProgress
    }
    func getInitialDeadline() -> TimeInterval {
        return TimeInterval(taskModel.initialDeadLine)
    }
    func getCurrentDeadline() -> TimeInterval {
        return TimeInterval(taskModel.postponableDeadLine)
    }
    
    func saveProgressPeriod(_ period: ProgressPeriod) {
        let period = createPeriodModel(from: period)
        taskModel.addToPeriodsOfProcess(period)
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
    
    func addTags(_ tags: ImmutableTagStore) {
        let tagArray = tags.tags
        let tagModels = NSOrderedSet(array: tagArray.map({ $0.tagModel }))
        taskModel.addToTags(tagModels)
        PersistanceService.saveContext()
    }
    
    func postponeDeadlineFor(_ timeInterval: TimeInterval) {
        let timeSpentInprogress = getTimeSpentInProgress()
        let newDeadLine = timeInterval + timeSpentInprogress
        setPostponableDeadline(newDeadLine)
    }
    private func setPostponableDeadline(_ newDeadline: TimeInterval) {
        taskModel.postponableDeadLine = Int16(newDeadline)
        PersistanceService.saveContext()
    }
}

extension TaskImp {
    private func createPeriodModel(from taskProgressPeriod: ProgressPeriod) -> PeriodModel {
        let period = PeriodModel(context: PersistanceService.context)
        let dateStarted = taskProgressPeriod.dateStarted as NSDate
        let dateFinished = taskProgressPeriod.dateEnded as NSDate
        period.dateStarted = dateStarted
        period.dateFinished = dateFinished
        return period
    }
}

