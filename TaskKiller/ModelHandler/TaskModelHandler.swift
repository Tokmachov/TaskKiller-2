//
//  ModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct TaskModelHandler: TaskModelCreating, TaskInfoGetableHandler {
  
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
    
    //MARK: TaskModelCreating
    init() {
        self.task = nil
    }
    mutating func createTask(from taskStaticInfo: TaskStaticInfo) {
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
        
        self.task = task
        
        PersistanceService.saveContext()
    }
}

extension TaskModelHandler {
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
