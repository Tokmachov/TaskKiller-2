//
//  File.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskListModel: TaskInitiatable {
    var taskDescription: String { get }
    var tagsStore: ImmutableTagStore { get }
}

struct TaskListModelImp: TaskListModel {
    
    private let task: Task

    init(task: Task) {
        self.task = task
    }
    var taskDescription: String {
        return task.getTaskDescription()
    }
    var tagsStore: ImmutableTagStore {
        return task.tagsStore
    }
}
