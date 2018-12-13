//
//  TaskModelFactory.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct TaskModelFacadeFactory: ITaskModelFacadeFactory {
    
    static func createTaskModelFacade(from taskModel: Task) -> ITaskModelFacade {
        return TaskModelFacade(task: taskModel)
    }
    
    static func createTaskModelFacade(from taskStaticInfo: TaskStaticInfo) -> ITaskModelFacade {
        let task = createTask(from: taskStaticInfo)
        let taskModelHandler = TaskModelFacade(task: task)
        return taskModelHandler
    }
}

extension TaskModelFacadeFactory {
    static private func createTask(from taskStaticInfo: TaskStaticInfo) -> Task {
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = Int16(taskStaticInfo.initialDeadLine)
        let postponableDeadline = Int16(taskStaticInfo.initialDeadLine)
        let tagsInfos = taskStaticInfo.tagsInfos
        let currentDate = Date() as NSDate
        let task = Task(context: PersistanceService.context)
        let tags = createTags(from: tagsInfos)
        let noTimeSpentInProgress = Int16(0)
        
        task.taskDescription = taskDescription
        task.deadLine = initiaLdeadLine
        task.postponableDeadLine = postponableDeadline
        task.addToTags(tags)
        task.dateCreated = currentDate
        task.timeSpentInProgress = noTimeSpentInProgress
        
        PersistanceService.saveContext()
        
        return task
    }
    static private func createTags(from tagInfos: AllTags) -> NSSet {
        var tags = [Tag]()
        for tagInfo in tagInfos.getTagsInfos() {
            let tag = Tag(context: PersistanceService.context)
            tag.projectName = tagInfo.projectName
            tags.append(tag)
        }
        return NSSet(array: tags)
    }
}


