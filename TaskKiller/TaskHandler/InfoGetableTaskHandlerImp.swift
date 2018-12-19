//
//  TaskInfoGetableModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation



struct InfoGetableTaskHandlerImp: InfoGetableTaskHandler {
    
    private let taskModelFacade: Task
    
    init(taskModelFacade: Task) {
        self.taskModelFacade = taskModelFacade
    }
    
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInProgress = taskModelFacade.getTimeSpentInProgress()
        let currentDeadline = taskModelFacade.getPostponableDeadLine()
        return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: currentDeadline)
    }
    
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = taskModelFacade.getTaskDescription()
        let initialDeadline = taskModelFacade.getInitialDeadLine()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: initialDeadline)
    }
}
