//
//  ITaskModelHandlingFactory.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskFactory {
    func createTask(from taskStaticInfo: TaskStaticInfo) -> Task
    func createTask(from taskModel: TaskModel) -> Task
}
