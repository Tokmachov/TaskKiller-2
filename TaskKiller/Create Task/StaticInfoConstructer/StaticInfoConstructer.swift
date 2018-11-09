//
//  StaticInfoConstructer.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

class StaticInfoConstructer: StaticInfoGathering {

    private var taskDescription: String!
    private var initialDeadLine: TimeInterval!
    private var tagsInfos: [TagInfo]!
    
    private var staticInfo: TaskStaticInfo {
        return TaskStaticInfo(taskDescription: taskDescription, initialDeadLine: initialDeadLine, tagsInfos: tagsInfos)
    }
    init() {}
    
    func receiveTaskDescription(_ taskDescription: String) {
        self.taskDescription = taskDescription
    }
    
    func receiveDeadLine(_ deadLine: TimeInterval) {
        self.initialDeadLine = deadLine
    }
    
    func receiveTagsInfos(_ tagsInfos: [TagInfo]) {
        self.tagsInfos = tagsInfos
    }
    
    func getStaticInfo() -> TaskStaticInfo {
        return staticInfo
    }
}
