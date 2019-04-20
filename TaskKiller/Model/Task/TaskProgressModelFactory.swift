//
//  TaskProgressModelFactory.swift
//  TaskKiller
//
//  Created by mac on 20/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskProgressModelFactory {
    func makeTaskProgressModel(task: Task) -> TaskProgressModel
}

struct TaskProgressModelFactoryImp: TaskProgressModelFactory {
    func makeTaskProgressModel(task: Task) -> TaskProgressModel {
        return TaskProgressModelImp(task: task)
    }
}

extension TaskProgressModelFactoryImp {
    
    struct TaskProgressModelImp: TaskProgressModel {
        
        private let task: Task
        
        init(task: Task) {
            self.task = task
        }
        
        //MARK: TaskStaticInfoSource
        var staticInfo: TaskStaticInfo {
            let description = task.description
            let deadLine = task.initialDeadline
            let tagsStore = task.tagsStore
            let staticInfo = TaskStaticInfo(
                taskDescription: description,
                initialDeadLine: deadLine,
                tagsStore: tagsStore
            )
            return staticInfo
        }
        
        //MARK: TaskProgressSaving
        func saveProgressPeriod(_ period: ProgressPeriod) {
            task.saveProgressPeriod(period)
        }
        //MARK: ProgressTimesSource
        var progressTimes: TaskProgressTimes {
            let timeLeftToDeadlineTimeIntervalValue = task.currentDeadline - task.timeSpentInProgress
            let timeLeftToDeadline = TimeLeftToDeadLine(timeLeftToDeadLine: timeLeftToDeadlineTimeIntervalValue)
            let progressTimes = TaskProgressTimes(
                timeSpentInprogress: task.timeSpentInProgress,
                timeLeftToDeadLine: timeLeftToDeadline
            )
            return progressTimes
        }
        
        //MARK: DeadlinePostponable
        func postponeDeadlineFor(_ timeInterval: TimeInterval) {
            task.postponeDeadlineFor(timeInterval)
        }
    }

}
