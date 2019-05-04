//
//  File.swift
//  TaskKiller
//
//  Created by mac on 09/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol TaskListModelFactory {
    func makeTaskListModel(task: Task) -> TaskListModel
}

struct TaskListModelFactoryImp: TaskListModelFactory {
    
    func makeTaskListModel(task: Task) -> TaskListModel {
        return TaskListModelImp(task: task)
    }
}
extension TaskListModelFactoryImp {
    struct TaskListModelImp: TaskListModel {
        let task: Task
        var taskDescription: String {
            return task.description
        }
        var tagsStore: ImmutableTagStore {
            return task.tagsStore
        }
    }
}
