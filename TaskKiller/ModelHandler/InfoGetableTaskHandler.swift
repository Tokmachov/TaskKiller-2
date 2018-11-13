//
//  TaskInfoGetableFacade.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct InfoGetableTaskHandler: IInfoGetableTaskHandler {
    
    private let taskModelFacade: ITaskModelFacade
    
    init(taskModelFacade: ITaskModelFacade) {
        self.taskModelFacade = taskModelFacade
    }
    
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = taskModelFacade.getTaskDescription()
        let deadLine = taskModelFacade.getDeadLine()
        let tagsInfosList = taskModelFacade.getTagsInfosList()
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: deadLine, tagsInfos: tagsInfosList)
    }
    
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInProgress = taskModelFacade.getTimeSpentInProgress()
        let postponableDeadLines = taskModelFacade.getPostponableDeadLine()
        return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: postponableDeadLines)
    }
    
    
}
