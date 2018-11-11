//
//  TaskModelCreator.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskModelCreator: TaskModelCreatingModelHandler {
    
    //MARK: TaskModelCreating
    mutating func createTask(from taskStaticInfo: TaskStaticInfo) -> Task  {
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = Int16(taskStaticInfo.initialDeadLine)
        let postponableDeadline = Int16(taskStaticInfo.initialDeadLine)
        let tagsInfos = taskStaticInfo.tagsInfos
        let currentDate = Date() as NSDate
        let task = Task(context: PersistanceService.context)
        let tags = createTags(from: tagsInfos)
        let noTimeSpentInProgress = Int16(0)
        
        task.goalDescription = taskDescription
        task.deadLine = initiaLdeadLine
        task.postponableDeadLine = postponableDeadline
        task.addToTags(tags)
        task.dateCreated = currentDate
        task.timeSpentInProgress = noTimeSpentInProgress
        
        PersistanceService.saveContext()
        return task
    }
}
extension TaskModelCreator {
    private func createTags(from tagInfos: TagsInfosList) -> NSSet {
        var tags = [Tag]()
        for tagInfo in tagInfos.getTagsInfos() {
            let tag = Tag(context: PersistanceService.context)
            tag.projectName = tagInfo.projectName
            tags.append(tag)
        }
        return NSSet(array: tags)
    }
}

