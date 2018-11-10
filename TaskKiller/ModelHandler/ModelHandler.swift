//
//  ModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct ModelHandler: ModelInitiatable, TaskStaticInfoGetable {
    
    private var task: Task?
    
    //MARK:ModelInitiatable
    init(taskStaticInfoSource: TaskStaticInfo) {
        self.task = nil
        self.task = createTask(from: taskStaticInfoSource)
    }
    init(task: Task) {
        self.task = task
    }
    
    //MARK: TaskStaticInfoGetable
    func getStaticInfo() -> TaskStaticInfo {
        let taskDescription = task!.description
        let initialDeadLine = TimeInterval(task!.deadLine)
        let tagsInfoList = getTagsInfosList()
        let taskStaticInfo = TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: initialDeadLine, tagsInfos: tagsInfoList)
        return taskStaticInfo
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
        task.addToTags(tags)
        PersistanceService.saveContext()
        return task
    }
    private func createTags(from tagInfos: TagsInfosList) -> NSSet {
        var tags = [Tag]()
        for tagInfo in tagInfos.getTagsInfos() {
            let tag = Tag(context: PersistanceService.context)
            tag.projectName = tagInfo.projectName
            tags.append(tag)
        }
        return NSSet(array: tags)
    }
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

