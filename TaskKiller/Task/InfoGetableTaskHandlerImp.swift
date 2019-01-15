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
    
    init(task: Task) {
        self.task = task
    }
    
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInProgress = task.getTimeSpentInProgress()
        let currentDeadline = task.getPostponableDeadLine()
        return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: currentDeadline)
    }
    
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = task.getTaskDescription()
        let initialDeadline = task.getInitialDeadLine()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: initialDeadline)
    }
}
