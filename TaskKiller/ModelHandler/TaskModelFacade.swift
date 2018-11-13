//
//  TaskModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskModelFacade: ITaskModelFacade {
    
    private var task: Task
    init(task: Task) {
        self.task = task
    }
    func getTaskDescription() -> String {
        return self.task.taskDescription!
    }
    func getDeadLine() -> TimeInterval {
        return TimeInterval(task.deadLine)
    }
    func getPostponableDeadLine() -> TimeInterval {
        return TimeInterval(task.postponableDeadLine)
    }
    
    func getTimeSpentInProgress() -> TimeInterval {
        return TimeInterval(task.timeSpentInProgress)
    }
    
    func getTagsInfosList() -> TagsInfosList {
        guard task.tags != nil else { return TagsInfosList() }
        var tagsInfosList = TagsInfosList()
        for tag in task.tags! {
            let tagName = (tag as! Tag).projectName!
            let  tagInfo = TagInfo(projectName: tagName)
            tagsInfosList.addTagInfo(tagInfo)
        }
        return tagsInfosList
    }
}
