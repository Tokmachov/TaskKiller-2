//
//  TaskModelFactory.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct TaskFactoryImp: TaskFactory {
    
    func createTask(from taskModel: TaskModel) -> Task {
        return TaskModelAdapter(task: taskModel)
    }
    
    func createTask(from taskStaticInfo: TaskStaticInfo) -> Task {
        let taskModel = createTaskModel(from: taskStaticInfo)
        let taskModelFacade = TaskModelAdapter(task: taskModel)
        return taskModelFacade
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


