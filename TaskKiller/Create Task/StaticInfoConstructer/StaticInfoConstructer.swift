//
//  StaticInfoConstructer.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct StaticInfoConstructer: StaticInfoConstructing {
    
    private var taskDescription: String!
    private var initialDeadLine: TimeInterval!
    private var tags: [TaskTag]!
    
    private var staticInfo: StaticInfo {
        return StaticInfo(taskDescription: taskDescription, initialDeadLine: initialDeadLine, tags: tags)
    }
    
    
    mutating func receiveTaskDescription(_ taskDescription: String) {
        self.taskDescription = taskDescription
    }
    mutating func receiveDeadLine(_ deadLine: TimeInterval) {
        self.initialDeadLine = deadLine
    }
    mutating func receiveTags(_ tags: [TaskTag]) {
        self.tags = tags
    }
    
    func getStaticInfo() -> StaticInfo {
        return staticInfo
    }
}
