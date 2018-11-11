//
//  ModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct TaskProgressTracker: TaskProgressTrackingModelHandler  {
  
    private var task: Task?
    
    //MARK: TaskInfoGetableHandler
    init(task: Task) {
        self.task = task
    }
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = task!.goalDescription!
        let initialDeadLine = TimeInterval(task!.deadLine)
        let tagsInfoList = getTagsInfosList()
        let taskStaticInfo = TaskStaticInfo.init(taskDescription: taskDescription , initialDeadLine: initialDeadLine, tagsInfos: tagsInfoList)
        return taskStaticInfo
    }
    func getProgressTimes() -> TaskProgressTimes {
        let timeSpentInprogress = TimeInterval(task!.timeSpentInProgress)
        let postponableDeadLine = TimeInterval(task!.postponableDeadLine)
        let taskProgressTimes = TaskProgressTimes.init(timeSpentInprogress: timeSpentInprogress, currentDeadLine: postponableDeadLine)
        return taskProgressTimes
    }
}

extension TaskProgressTracker {

    private func getTagsInfosList() -> TagsInfosList {
        guard task?.tags != nil else { return TagsInfosList() }
        var tagsInfosList = TagsInfosList()
        for tag in task!.tags! {
            let tagName = (tag as! Tag).projectName!
            let  tagInfo = TagInfo(projectName: tagName)
            tagsInfosList.addTagInfo(tagInfo)
        }
        return tagsInfosList
    }
}
