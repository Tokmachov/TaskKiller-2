//
//  ModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct ModelHandler: ModelInitiatable {
    
    private var task: Task?
    
    init(taskStaticInfoSource: TaskStaticInfo) {
        self.task = nil
        self.task = createTask(from: taskStaticInfoSource)
    }
    private func createTask(from taskStaticInfo: TaskStaticInfo) -> Task {
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = Int16(taskStaticInfo.initialDeadLine)
        let postponableDeadline = Int16(taskStaticInfo.initialDeadLine)
        let tagsInfos = taskStaticInfo.tagsInfos
        
        let task = Task(context: PersistanceService.context)
        let tags = createTags(from: tagsInfos)
        task.goalDescription = taskDescription
        task.deadLine = initiaLdeadLine
        task.postponableDeadLine = postponableDeadline
        for tag in tags {
            task.addToTags(tag)
        }
        PersistanceService.saveContext()
        return task
    }
    private func createTags(from tagInfos: [TagInfo]) -> [Tag] {
        var tags = [Tag]()
        for tagInfo in tagInfos {
            let tag = Tag(context: PersistanceService.context)
            tag.projectName = tagInfo.progectName
            tags.append(tag)
        }
        return tags
    }
}
