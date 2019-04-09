//
//  ITaskModelHandlingFactory.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskFactory {
    func makeTask(taskStaticInfo: TaskStaticInfo) -> Task
    func makeTask(taskModel: TaskModel) -> Task
}

import CoreData

struct TaskFactoryImp: TaskFactory {
    
    func makeTask(taskModel: TaskModel) -> Task {
        return TaskImp(task: taskModel)
    }
    
    func makeTask(taskStaticInfo: TaskStaticInfo) -> Task {
        let taskModel = createTaskModel(from: taskStaticInfo)
        let task = TaskImp(task: taskModel)
        task.addTags(taskStaticInfo.tags)
        return task
    }
}

extension TaskFactoryImp {
    private func createTaskModel(from taskStaticInfo: TaskStaticInfo) -> TaskModel {
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = Int16(taskStaticInfo.initialDeadLine)
        let postponableDeadline = Int16(taskStaticInfo.initialDeadLine)
        let currentDate = Date() as NSDate
        let taskModel = TaskModel(context: PersistanceService.context)
        
        taskModel.taskDescription = taskDescription
        taskModel.initialDeadLine = initiaLdeadLine
        taskModel.postponableDeadLine = postponableDeadline
        taskModel.dateCreated = currentDate
        PersistanceService.saveContext()
        
        return taskModel
    }
}
