//
//  StaticInfoConstructer.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

class TaskStaticInfoController: StaticInfoGathering {

    private var taskDescription: String!
    private var initialDeadLine: TimeInterval!
    
    private var staticInfo: TaskStaticInfo {
        return TaskStaticInfo(taskDescription: taskDescription, initialDeadLine: initialDeadLine)
    }
    init() {}
    
    func receiveTaskDescription(_ taskDescription: String) {
        self.taskDescription = taskDescription
    }
    
    func receiveDeadLine(_ deadLine: TimeInterval) {
        self.initialDeadLine = deadLine
    }
    
    func createStaticInfo() -> TaskStaticInfo {
        return staticInfo
    }
}
