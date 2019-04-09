//
//  File.swift
//  TaskKiller
//
//  Created by mac on 09/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol TaskListImmutableModelFactory {
    init(taskModelFetchResultsController: NSFetchedResultsController<TaskModel>, taskFactory: TaskFactory)
    func makeTaskListImmutableModel(taskModelIndexPath indexPath: IndexPath) -> TaskListImmutableModel
}

struct TaskListImmutableModelFactoryImp: TaskListImmutableModelFactory {
    
    private var fetchResultsController: NSFetchedResultsController<TaskModel>
    private var taskFactory: TaskFactory
    
    init(taskModelFetchResultsController: NSFetchedResultsController<TaskModel>, taskFactory: TaskFactory) {
        self.fetchResultsController = taskModelFetchResultsController
        self.taskFactory = taskFactory
    }
    
    func makeTaskListImmutableModel(taskModelIndexPath indexPath: IndexPath) -> TaskListImmutableModel {
        let taskModel = fetchResultsController.object(at: indexPath)
        let task = TaskImp(task: taskModel)
        return TaskListImmutableModelImp(task: task)
    }
}
