//
//  TaskModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskModelFacade: ITaskModelFacade {
 
    private var task: Task
    init(task: Task) {
        self.task = task
    }
    func getTaskDescription() -> String {
        return self.task.taskDescription!
    }
    func getDeadLine() -> TimeInterval {
        return TimeInterval(task.deadLine)
    }
    func getPostponableDeadLine() -> TimeInterval {
        return TimeInterval(task.postponableDeadLine)
    }
    
    func getTimeSpentInProgress() -> TimeInterval {
        return TimeInterval(task.timeSpentInProgress)
    }
    
    func getTagsInfosList() -> TagsInfosList {
        guard task.tags != nil else { return TagsInfosList() }
        var tagsInfosList = TagsInfosList()
        for tag in task.tags! {
            let tagName = (tag as! Tag).projectName!
            let  tagInfo = TagInfo(projectName: tagName)
            tagsInfosList.addTagInfo(tagInfo)
        }
        return tagsInfosList
    }
    func saveProgress(progressTimes: TaskProgressTimes, taskProgressPeriod: TaskProgressPeriod) {
        let timeSpentInProgress = Int16(progressTimes.timeSpentInprogress)
        let postponableDeadline = Int16(progressTimes.currentDeadLine)
        let period = createPeriod(from: taskProgressPeriod)
        task.timeSpentInProgress = timeSpentInProgress
        task.postponableDeadLine = postponableDeadline
        task.addToPeriodsOfProcess(period)
        PersistanceService.saveContext()
    }
}

extension TaskModelFacade {
    private func createPeriod(from taskProgressPeriod: TaskProgressPeriod) -> Period {
        let period = Period(context: PersistanceService.context)
        let dateStarted = taskProgressPeriod.dateStarted as NSDate
        let dateFinished = taskProgressPeriod.dateEnded as NSDate
        period.dateStarted = dateStarted
        period.dateFinished = dateFinished
        return period
    }
}
